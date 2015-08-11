//
//  CodedInputStream.swift
//  StructBuf
//
//  Created by David Paschich on 8/4/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import Cocoa

class CodedInputStream {

    var bytes: [UInt8]

    init(bytes: [UInt8]) {
        self.bytes = bytes
    }

    func readFixed32Unsigned() throws -> UInt32 {
        guard bytes.count >= 4 else { throw StructBufError.ParseFailed }
        var result: UInt32 = 0
        result += UInt32(bytes[0])
        result += UInt32(bytes[1]) << 8
        result += UInt32(bytes[2]) << 16
        result += UInt32(bytes[3]) << 24

        bytes = [UInt8](bytes.dropFirst(4))
        return result
    }

    func generator() throws -> AnyGenerator<Field> {
        throw StructBufError.NotImplemented
    }
}
