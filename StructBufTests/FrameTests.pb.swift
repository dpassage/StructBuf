//
//  FrameTests.pb.swift
//  StructBuf
//
//  Created by David Paschich on 7/25/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import XCTest
import StructBuf

class FrameTests_pb: XCTestCase {
    func testReadSimpleMessage() {
        let tag: UInt8 = UInt8(1 << 3) + UInt8(WireType.Fixed32.rawValue)
        let bytes = [tag, 0x1, 0x0, 0x0, 0x0]

        do {
            let frame = try Frame(bytes: bytes)
            XCTAssertEqual(frame.size, 1)
            XCTAssertEqual(0, frame.unknownFields.keys.count)
        } catch {
            XCTFail("should not have thrown")
        }
    }
}
