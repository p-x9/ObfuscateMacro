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
        case "AES": self = .AES
        case "chaChaPoly": self = .chaChaPoly
        case "randomAll": self = .randomAll
        case "randomAllCrypto": self = .randomAllCrypto
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
        case "AES": self = .AES
        case "chaChaPoly": self = .chaChaPoly
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
        case .AES:
            return [.AES]
        case .chaChaPoly:
            return [.chaChaPoly]
        case .randomAll:
            return Element.allCases
        case .randomAllCrypto:
            return Element.allCases.filter(\.usesCrypto)
        case .random(let array):
            return array
        }
    }
}
