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
    var bytes: [UInt8]
    var unknownFields:[Int:[WireValue]] { return [:] }
    init?(bytes: [UInt8]) { self.bytes = bytes }
}

class MessageTests: XCTestCase {

    func testSizeIsCorrect() {
        let message = TestMessage(bytes: [0,1,2])!
        XCTAssertEqual(message.serializedSize, 3)
    }
}
