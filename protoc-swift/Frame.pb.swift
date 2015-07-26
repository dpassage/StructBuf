//
//  Frame.pb.swift
//  StructBuf
//
//  Created by David Paschich on 6/12/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import Foundation
import StructBuf

struct Frame: Message {

    var size: UInt32 = 0

    var bytes: [UInt8] = []
    var serializedSize: Int { return bytes.count }
    var unknownFields: [Int:[WireValue]] = [:]
    init(bytes: [UInt8]) throws {
        size = 1
    }
}