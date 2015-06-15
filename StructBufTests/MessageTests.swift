//
//  MessageTests.swift
//  StructBuf
//
//  Created by David Paschich on 6/12/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import XCTest
import StructBuf

struct TestMessage: Message {
    var bytes: [UInt8] { return [] }
    var serializedSize: Int { return 0 }
    var unknownFields:[Int:[WireValue]] { return [:] }
    init?(bytes: [UInt8]) { return nil }
}

class MessageTests: XCTestCase {

}
