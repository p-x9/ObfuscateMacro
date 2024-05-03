//
//  ObfuscatedString.swift
//
//
//  Created by p-x9 on 2023/07/18.
//
//

import Algorithms
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
#if canImport(CryptoKit)
import CryptoKit
#endif
import ObfuscateSupport

struct ObfuscatedString {
    typealias Diagnostic = ObfuscateMacroDiagnostic

    struct Arguments {
        /// The string to be obfuscated.
        let string: String
        /// obfuscation method
        let method: ObfuscateMethod
        /// Number of obfuscation repetitions
        let repetitions: Int

        init(
            string: String,
            method: ObfuscateMethod?,
            repetitions: Int = 1
        ) {
            self.string = string
            self.method = method ?? .randomAll
            self.repetitions = repetitions
        }
    }

    /// Parsing the syntax of macro argument lists
    /// - Parameter arguments: A syntax of macro argument list
    /// - Returns: Parsed arguments
    static func arguments(
        of arguments: LabeledExprListSyntax,
        context: some MacroExpansionContext
    ) -> Arguments? {
        guard let firstElement = arguments.first?.expression,
              let stringLiteral = firstElement.as(StringLiteralExprSyntax.self) else {
            return nil
        }
        let string = stringLiteral.segments.description

        guard arguments.count >= 2 else {
            return .init(string: string, method: nil)
        }

        let methodExpression = arguments.first(where: {
            $0.label?.trimmed.text == "method"
        })?.expression

        let repetitionsExpression = arguments.first(where: {
            $0.label?.trimmed.text == "repetitions"
        })?.expression

        var method: ObfuscateMethod?

        if let methodExpression,
           let accessExpr = methodExpression.as(MemberAccessExprSyntax.self) {
            let rawValue = accessExpr.declName.baseName.trimmed.text
            method = ObfuscateMethod(rawValue: rawValue)
        }

        if let methodExpression,
           let functionExpr = methodExpression.as(FunctionCallExprSyntax.self),
           let calledExpr = functionExpr.calledExpression.as(MemberAccessExprSyntax.self),
           calledExpr.declName.baseName.trimmed.text == "random",
           let argument = functionExpr.arguments.first?.expression.as(ArrayExprSyntax.self) {
            let elements = argument.elements.compactMap { $0.expression.as(MemberAccessExprSyntax.self)}
            let methodElements = elements.compactMap {
                let rawValue = $0.declName.baseName.trimmed.text
                return ObfuscateMethod.Element(rawValue: rawValue)
            }
            if !methodElements.isEmpty {
                method = .random(methodElements)
            } else {
                context.diagnose(Diagnostic.methodCandidateIsEmpty.diagnose(at: argument.elements))
                method = .random(ObfuscateMethod.Element.allCases)
            }
        }

        var repetitions = 1

        if let repetitionsExpression,
           let intExpr = repetitionsExpression.as(IntegerLiteralExprSyntax.self),
           let number = Int(intExpr.literal.trimmed.text), number > 0 {
            repetitions = number
        }

        return .init(string: string, method: method, repetitions: repetitions)
    }
}

extension ObfuscatedString: ExpressionMacro {
    static var randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        #if canImport(SwiftSyntax510)
        guard let arguments = arguments(of: node.arguments, context: context) else {
            let diagnostic = Diagnostic.failedToParseArguments.diagnose(at: node.arguments)
            context.diagnose(diagnostic)
            fatalError(diagnostic.message)
        }
        #else
        guard let arguments = arguments(of: node.argumentList, context: context) else {
            let diagnostic = Diagnostic.failedToParseArguments.diagnose(at: node.argumentList)
            context.diagnose(diagnostic)
            fatalError(diagnostic.message)
        }
        #endif

        let string = arguments.string

        let candidates = arguments.method.elements
        let randomMethod: () -> ObfuscateMethod.Element = {
            if candidates.isEmpty {
                fatalError("Invalid Argument")
            } else if candidates.count == 1 {
                return candidates[0]
            } else {
                let allCases = ObfuscateMethod.Element.allCases
                let index = Int.random(
                    in: allCases.startIndex..<allCases.endIndex,
                    using: &randomNumberGenerator
                )
                return allCases[index]
            }
        }

        let methods = (0..<arguments.repetitions).map { _ in
            randomMethod()
        }


        var codeBlockItems: [CodeBlockItemSyntax] = []
        var data = string.data(using: .utf8)!

        methods.forEach { method in
            switch method {
            case .bitShift:
                (codeBlockItems, data) = obfuscateByShift(codeBlockItems, data: data)
            case .bitXOR:
                (codeBlockItems, data) = obfuscateByXOR(codeBlockItems, data: data)
            case .base64:
                (codeBlockItems, data) = obfuscateByBase64(codeBlockItems, data: data)
#if canImport(CryptoKit)
            case .AES:
                (codeBlockItems, data) = obfuscateByAES(codeBlockItems, data: data)
#endif
            }
        }

        codeBlockItems = codeBlockItems.map {
            $0.with(\.trailingTrivia, .newline)
        }

        return """
        {
            var data = Data(\(raw: data.array!))

            \(CodeBlockItemListSyntax(codeBlockItems))
            return String(
                bytes: data,
                encoding: .utf8
            )!
        }()
        """
    }
}

extension ObfuscatedString {
    /// Obfuscates the given data using XOR operation.
    ///
    /// Using a random `seed` and the index `i` of the UTF8 element `c`, the following expression is obfuscated
    /// ```
    /// c ^ (seed + i)
    /// ```
    ///
    /// - Parameters:
    ///   - codeBlockItems:  List of current `CodeBlockItemSyntax` to decode the obfuscated data back to the original data.
    ///   - data: The data to be obfuscated.
    /// - Returns: Obfuscated data and ExprSyntax with additional decoding process
    static func obfuscateByShift(
        _ codeBlockItems: [CodeBlockItemSyntax],
        data: Data
    ) -> ([CodeBlockItemSyntax], Data) {
        let start: UTF8.CodeUnit = .random(
            in: 0x00...0xFF,
            using: &randomNumberGenerator
        )
        let step: UTF8.CodeUnit = .random(
            in: 0x0...0xF,
            using: &randomNumberGenerator
        )
        let obfuscatedDataElements = data.indexed().map { i, c in
            let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
            return c &+ (start &+ (step &* i))
        }
        let obfuscatedData = Data(obfuscatedDataElements)

        let codeBlockItem: CodeBlockItemSyntax = """
        data = Data(data.indexed().map { i, c in
            let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
            return c &- (\(raw: start) &+ (\(raw: step) &* i))
        })
        """

        let codeBlockItems = [codeBlockItem] + codeBlockItems

        return (codeBlockItems, obfuscatedData)
    }

    /// Obfuscates the given string using bit shift operation.
    ///
    /// Using a random `start`, `step` and the index `i` of the UTF8 element `c`, the following expression is obfuscated
    /// Use &+ and &- operators to account for overflow after a shift.
    /// ```
    /// c + (start + (step * i))
    /// ```
    ///
    /// - Parameters:
    ///   - codeBlockItems:  List of current `CodeBlockItemSyntax` to decode the obfuscated data back to the original data.
    ///   - data: The data to be obfuscated.
    /// - Returns: Obfuscated data and ExprSyntax with additional decoding process
    static func obfuscateByXOR(
        _ codeBlockItems: [CodeBlockItemSyntax],
        data: Data
    ) -> ([CodeBlockItemSyntax], Data) {
        let seed: UTF8.CodeUnit = .random(
            in: 0x00...0xFF,
            using: &randomNumberGenerator
        )
        let obfuscatedDataElements = data.indexed().map { i, c in
            let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
            return c ^ (seed &+ i)
        }
        let obfuscatedData = Data(obfuscatedDataElements)

        let codeBlockItem: CodeBlockItemSyntax = """
        data = Data(data.indexed().map { i, c in
            let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
            return c ^ (\(raw: seed) &+ i)
        })
        """

        let codeBlockItems = [codeBlockItem] + codeBlockItems

        return (codeBlockItems, obfuscatedData)
    }

    /// Obfuscates the given data using base64 operation.
    ///
    /// Using a random `start`, `step` and the index `i` of the UTF8 element `c`, the following expression is obfuscated
    /// Use &+ and &- operators to account for overflow after a shift.
    /// ```
    /// c + (start + (step * i))
    /// ```
    ///
    /// - Parameters:
    ///   - codeBlockItems:  List of current `CodeBlockItemSyntax` to decode the obfuscated data back to the original data.
    ///   - data: The data to be obfuscated.
    /// - Returns: Obfuscated data and ExprSyntax with additional decoding process
    static func obfuscateByBase64(
        _ codeBlockItems: [CodeBlockItemSyntax],
        data: Data
    ) -> ([CodeBlockItemSyntax], Data) {
        let base64String = data.base64EncodedString()

        let obfuscatedData = base64String.data(using: .utf8)!

        let codeBlockItem: CodeBlockItemSyntax = """
        data = Data(base64Encoded: String(data: data, encoding: .utf8)!)!
        """

        let codeBlockItems = [codeBlockItem] + codeBlockItems

        return (codeBlockItems, obfuscatedData)
    }

#if canImport(CryptoKit)
    /// Obfuscates the given string using AES operation.
    ///
    /// A 128-bit random key is used
    ///
    /// - Parameters:
    ///   - codeBlockItems:  List of current `CodeBlockItemSyntax` to decode the obfuscated data back to the original data.
    ///   - data: The data to be obfuscated.
    /// - Returns: Obfuscated data and ExprSyntax with additional decoding process
    static func obfuscateByAES(
        _ codeBlockItems: [CodeBlockItemSyntax],
        data: Data
    ) -> ([CodeBlockItemSyntax], Data) {
        let keyData = Data.symmetricKeyData(
            size: 16, // 128 bits
            using: &randomNumberGenerator
        )
        let key: SymmetricKey = .init(data: keyData)

        let nonceData = Data.nonceData(
            using: &randomNumberGenerator
        )

        guard let nonce = try? AES.GCM.Nonce(data: nonceData),
              let sealedBox = try? AES.GCM.seal(data, using: key, nonce: nonce),
              let encryptedData = sealedBox.combined else {
            return (codeBlockItems, data)
        }

        let codeBlockItem: CodeBlockItemSyntax = """
        data = try! AES.GCM.open(
            try! AES.GCM.SealedBox(
                combined: Data(\(raw: encryptedData.array!))
            ),
            using: SymmetricKey(
                data: Data(\(raw: keyData.array!))
            )
        )
        """

        let codeBlockItems = [codeBlockItem] + codeBlockItems

        return (codeBlockItems, encryptedData)
    }
#endif
}
