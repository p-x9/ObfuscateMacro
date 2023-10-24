//
//  Data+.swift
//
//
//  Created by p-x9 on 2023/10/25.
//  
//

import Foundation

extension Data {
    var array: [UInt8]? {
        return withUnsafeBytes({ (pointer: UnsafeRawBufferPointer) -> [UInt8] in
            let unsafeBufferPointer = pointer.bindMemory(to: UInt8.self)
            let unsafePointer = unsafeBufferPointer.baseAddress!
            return [UInt8](UnsafeBufferPointer(start: unsafePointer, count: self.count))
        })
    }
}
