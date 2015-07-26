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
    init<S: SequenceType where S.Generator.Element == UInt8>(bytes: S) throws { self.bytes = [UInt8](bytes) }
}

class MessageTests: XCTestCase {

    func testSizeIsCorrect() {
        let message = try! TestMessage(bytes: [0,1,2])
        XCTAssertEqual(message.serializedSize, 3)
    }
}
