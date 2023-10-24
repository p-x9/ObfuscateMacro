//
//  Method.swift
//  
//
//  Created by p-x9 on 2023/10/25.
//  
//

import Foundation

public enum ObfuscateMethod {
    public enum Element: CaseIterable {
        case bitShift
        case bitXOR
        case base64
        case AES
    }

    case bitShift
    case bitXOR
    case base64
    case AES

    case randomAll
    case random([Element])
}
