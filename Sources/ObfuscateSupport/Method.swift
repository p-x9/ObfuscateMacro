//
//  Method.swift
//  
//
//  Created by p-x9 on 2023/10/25.
//  
//

import Foundation

/// Methods for obfuscating data.
public enum ObfuscateMethod {
    /// list of individual obfuscation techniques.
    public enum Element: CaseIterable {
        /// Obfuscation using bit shifting.
        case bitShift
        /// Obfuscation using bitwise XOR operation.
        case bitXOR
        /// Obfuscation using base64 encoding.
        case base64
        /// Obfuscation using AES encryption.
        case AES
        /// Obfuscation using ChaChaPoly encryption.
        case chaChaPoly

        /// `true` if the method uses a secure method from `swift-crypto`
        public var usesCrypto: Bool {
            switch self {
            case .AES, .chaChaPoly:
                true
            default:
                false
            }
        }
    }
    
    /// Obfuscation using bit shifting.
    case bitShift
    /// Obfuscation using bitwise XOR operation.
    case bitXOR
    /// Obfuscation using base64 encoding.
    case base64
    /// Obfuscation using AES encryption.
    case AES
    /// Obfuscation using ChaChaPoly encryption.
    case chaChaPoly

    /// Randomly selects one obfuscation method from all available methods.
    case randomAll
    /// Randomly selects one obfuscation method from all available methods that use advanced cryptography.
    case randomAllCrypto
    /// Randomly selects obfuscation methods from a specified list of `Element` cases.
    case random([Element])
}
