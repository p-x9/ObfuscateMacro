//
//  ObfuscateMacroDiagnostic.swift
//
//
//  Created by p-x9 on 2023/10/25.
//  
//

import SwiftSyntax
import SwiftDiagnostics

public enum ObfuscateMacroDiagnostic {
    case failedToParseArguments
    case methodCandidateIsEmpty
}

extension ObfuscateMacroDiagnostic: DiagnosticMessage {
    func diagnose(at node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: Syntax(node), message: self)
    }

    public var message: String {
        switch self {
        case .failedToParseArguments:
            return "Failed to parse arguments of this macro"
        case .methodCandidateIsEmpty:
            return "The element specified in `ObfuscateMethod.random` is empty."
        }
    }

    public var severity: DiagnosticSeverity {
        switch self {
        case .methodCandidateIsEmpty:
            return .warning
        default:
            return .error
        }
    }

    public var diagnosticID: MessageID {
        MessageID(domain: "Swift", id: "ObfuscateMacro.\(self)")
    }
}
