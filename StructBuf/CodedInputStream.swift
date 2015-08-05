//
//  CodedInputStream.swift
//  StructBuf
//
//  Created by David Paschich on 8/4/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import Cocoa

class CodedInputStream {

    init(bytes: [UInt8]) {

    }

    func readFixed32Unsigned() -> UInt32 {
        return 0
    }

    func generator() throws -> AnyGenerator<Field> {
        throw StructBufError.NotImplemented
    }
}
