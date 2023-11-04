//
//  ObfuscateMethod+.swift
//  
//
//  Created by p-x9 on 2023/10/25.
//  
//

import Foundation
import ObfuscateSupport

extension ObfuscateMethod {
    init?(rawValue: String) {
        switch rawValue {
        case "bitShift": self = .bitShift
        case "bitXOR": self = .bitXOR
        case "base64": self = .base64
#if canImport(CryptoKit)
        case "AES": self = .AES
#endif
        case "randomAll": self = .randomAll
        default: return nil
        }
    }
}

extension ObfuscateMethod.Element {
    init?(rawValue: String) {
        switch rawValue {
        case "bitShift": self = .bitShift
        case "bitXOR": self = .bitXOR
        case "base64": self = .base64
#if canImport(CryptoKit)
        case "AES": self = .AES
#endif
        default: return nil
        }
    }
}

extension ObfuscateMethod {
    var elements: [Element] {
        switch self {
        case .bitShift:
            return [.bitShift]
        case .bitXOR:
            return [.bitXOR]
        case .base64:
            return [.base64]
#if canImport(CryptoKit)
        case .AES:
            return [.AES]
#endif
        case .randomAll:
            return Element.allCases
        case .random(let array):
            return array
        }
    }
}
