//
//  ObfuscatedString.swift
//
//
//  Created by p-x9 on 2023/07/18.
//  
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
import CryptoKit
import ObfuscateSupport

struct ObfuscatedString {
    struct Arguments {
        let string: String
        let method: ObfuscateMethod

        init(string: String, method: ObfuscateMethod?) {
            self.string = string
            self.method = method ?? .randomAll
        }
    }

    static func arguments(of arguments: LabeledExprListSyntax) -> Arguments? {
        guard let firstElement = arguments.first?.expression,
              let stringLiteral = firstElement.as(StringLiteralExprSyntax.self) else {
            return nil
        }
        let string = stringLiteral.segments.description

        guard arguments.count >= 2,
              let expression = arguments.last?.expression else {
            return .init(string: string, method: nil)
        }

        var method: ObfuscateMethod?

        if let accessExpr = expression.as(MemberAccessExprSyntax.self) {
            let rawValue = accessExpr.declName.baseName.trimmed.text
            method = ObfuscateMethod(rawValue: rawValue)
        }

        if let functionExpr = expression.as(FunctionCallExprSyntax.self),
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
            }
        }

        return .init(string: string, method: method)
    }
}

extension ObfuscatedString: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let arguments = arguments(of: node.argumentList) else {
            fatalError()
        }

        let string = arguments.string

        let methods = arguments.method.elements
        let method = methods.randomElement() ?? .bitXOR

        switch method {
        case .bitShift:
            return obfuscateByShift(string)
        case .bitXOR:
            return obfuscateByXOR(string)
        case .base64:
            return obfuscateByBase64(string)
        case .AES:
            return obfuscateByAES(string)
        }
    }
}

extension ObfuscatedString {
    static func obfuscateByXOR(_ string: String) -> ExprSyntax {
        let seed: UTF8.CodeUnit = (0x00...0xFF).randomElement() ?? 0xFF
        let obfuscatedData = string.utf8.enumerated().map { i, c in c ^ (seed + UTF8.CodeUnit(i)) }

        return """
        {
            String(
                bytes: Data(\(raw: obfuscatedData)).enumerated().map { i, c in c ^ (\(raw: seed) + UTF8.CodeUnit(i)) },
                encoding: .utf8
            )!
        }()
        """
    }

    static func obfuscateByShift(_ string: String) -> ExprSyntax {
        let start: UTF8.CodeUnit = (0x00...0xFF).randomElement() ?? 0xFF
        let step: UTF8.CodeUnit = (0x00...0xF).randomElement() ?? 0xFF
        let obfuscatedData = string.utf8.enumerated().map { i, c in c &+ (start &+ (step &* UTF8.CodeUnit(i))) }

        return """
        {
            String(
                bytes: Data(\(raw: obfuscatedData)).enumerated().map { i, c in c &- (\(raw: start) &+ (\(raw: step) &* UTF8.CodeUnit(i))) },
                encoding: .utf8
            )!
        }()
        """
    }

    static func obfuscateByBase64(_ string: String) -> ExprSyntax {
        guard let data = string.data(using: .utf8) else {
            return "\"\(raw: string)\""
        }
        let base64String = data.base64EncodedString()

        return """
        {
            String(
                bytes: Data(base64Encoded: "\(raw: base64String)")!,
                encoding: .utf8
            )!
        }()
        """
    }

    static func obfuscateByAES(_ string: String) -> ExprSyntax {
        let key: SymmetricKey = .init(size: .bits128)
        let keyData = key.withUnsafeBytes { Data($0) }

        guard let data = string.data(using: .utf8),
              let sealedBox = try? AES.GCM.seal(data, using: key),
              let encryptedData = sealedBox.combined else {
            return "\"\(raw: string)\""
        }
        

        return """
        {
            let sb = try! AES.GCM.SealedBox(combined: Data(\(raw: encryptedData.array!))) // sealedBox
            let dd = try! AES.GCM.open(sb, using: SymmetricKey(data: Data(\(raw: keyData.array!)))) // decryptedData
            return String(
                bytes: dd,
                encoding: .utf8
            )!
        }()
        """
    }
}
