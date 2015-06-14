//
//  Frame.pb.swift
//  StructBuf
//
//  Created by David Paschich on 6/12/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import Foundation

struct Frame: Message {

    var size: UInt32

    var bytes: [UInt8]
    var serializedSize: Int
    var unknownFields: [Int:[WireValue]]
    init?(bytes: [UInt8]) {
        return nil
    }
}