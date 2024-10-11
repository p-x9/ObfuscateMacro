//
//  Data+.swift
//
//
//  Created by p-x9 on 2023/10/25.
//  
//

import Foundation
import Crypto

extension Data {
    var array: [UInt8]? {
        return withUnsafeBytes({ (pointer: UnsafeRawBufferPointer) -> [UInt8] in
            let unsafeBufferPointer = pointer.bindMemory(to: UInt8.self)
            let unsafePointer = unsafeBufferPointer.baseAddress!
            return [UInt8](UnsafeBufferPointer(start: unsafePointer, count: self.count))
        })
    }
}

extension Data {
    /// Generates a new random symmetric key data of the given size.
    /// - Parameters:
    ///   - size: The size of the key to generate. [byte]
    ///   - generator: The random number generator to use when creating the new random value.
    /// - Returns: A random symmetric key data
    static func symmetricKeyData<T>(
        size: Int,
        using generator: inout T
    )  -> Self where T : RandomNumberGenerator {
        var keyData = Data(count: size)

        keyData.withUnsafeMutableBytes{ bufferPointer in
            guard let baseAddress = bufferPointer.baseAddress else {
                return
            }
            for i in 0..<bufferPointer.count {
                let randomByte = UInt8.random(
                    in: 0...UInt8.max,
                    using: &generator
                )
                baseAddress.advanced(by: i).storeBytes(of: randomByte, as: UInt8.self)
            }
        }

        return keyData
    }

    /// Generates a new random nonce data of the given size.
    ///
    /// The default nonce is a 12-byte random nonce.
    ///
    /// - Parameters:
    ///   - generator: The random number generator to use when creating the new random value.
    /// - Returns: A random symmetric key data
    static func nonceData<T>(
        using generator: inout T
    )  -> Self where T : RandomNumberGenerator {
        var nonceData = Data(count: 12)
        nonceData.withUnsafeMutableBytes{ bufferPointer in
            guard let baseAddress = bufferPointer.baseAddress else {
                return
            }
            for i in 0..<bufferPointer.count {
                let randomByte = UInt8.random(
                    in: 0...UInt8.max,
                    using: &generator
                )
                baseAddress.advanced(by: i).storeBytes(of: randomByte, as: UInt8.self)
            }
        }

        return nonceData
    }
}
