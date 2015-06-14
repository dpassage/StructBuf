//
//  Message.swift
//  ProtocolBuffers
//
//  Created by David Paschich on 5/24/15.
//  Copyright (c) 2015 David Paschich. All rights reserved.
//

import Foundation

public protocol Message {
    var bytes: [UInt8] { get }
    var serializedSize: Int { get }
    var unknownFields: [Int:[WireValue]] { get }
    init?(bytes: [UInt8])
}

extension Message {
    var serializedSize: Int { return bytes.count }

    var bytes: [UInt8] { return [] }
    var unknownFields: [Int:[WireValue]] { return [:] }
    init?(bytes: [UInt8]) { return nil }
}