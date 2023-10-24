//
//  ObfuscateMacroPlugin.swift
//
//
//  Created by p-x9 on 2023/07/18.
//  
//

#if canImport(SwiftCompilerPlugin)
import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct ObfuscateMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ObfuscatedString.self
    ]
}
#endif
