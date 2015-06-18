//
//  StructBufTests.swift
//  StructBufTests
//
//  Created by David Paschich on 6/11/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import XCTest
@testable import StructBuf

class FieldTests: XCTestCase {

    func testFixed32Field() {
        let bytes: [UInt8] = [0x0d, 0x00, 0x00, 0x00, 0x00]
        do {
            let (field, bytes_read) = try Field.fromBytes(bytes)
            XCTAssertEqual(bytes_read, 5)
            XCTAssertEqual(field.number, 1)
            XCTAssert(field.value == WireValue.Fixed32(0))
        } catch {
            XCTFail("should not have thrown \(error)")
        }
    }
}

class WireValueTests: XCTestCase {

    func testTypeForVarint() {
        let value = WireValue.Varint(12)
        XCTAssertEqual(value.type, WireType.Varint)
    }

    func testTypeForFixed64() {
        let value = WireValue.Fixed64(1)
        XCTAssertEqual(value.type, WireType.Fixed64)
    }

    func testTypeForBytes() {
        let value = WireValue.Bytes([])
        XCTAssertEqual(value.type, WireType.Bytes)
    }

    func testTypeForStartGroup() {
        let value = WireValue.StartGroup
        XCTAssertEqual(value.type, WireType.StartGroup)
    }

    func testTypeForEndGroup() {
        let value = WireValue.EndGroup
        XCTAssertEqual(value.type, WireType.EndGroup)
    }

    func testTypeForFixed32() {
        let value = WireValue.Fixed32(1)
        XCTAssertEqual(value.type, WireType.Fixed32)
    }
}

class WireValueBytesTests: XCTestCase {
    func testVarint() {
        let value = WireValue.Varint(1)
        let bytes = value.bytes
        XCTAssertEqual(bytes, [1])
    }

    func testFixed64() {
        let value = WireValue.Fixed64(1)
        let bytes = value.bytes
        XCTAssertEqual(bytes, [1, 0, 0, 0, 0, 0, 0, 0])
    }

    func testBytes() {
        let value = WireValue.Bytes([1, 2, 3, 4, 5])
        let bytes = value.bytes
        XCTAssertEqual(bytes, [5, 1, 2, 3, 4, 5])
    }

    func testStartGroup() {
        let value = WireValue.StartGroup
        XCTAssertEqual(value.bytes, [])
    }

    func testEndGroup() {
        let value = WireValue.EndGroup
        XCTAssertEqual(value.bytes, [])
    }

    func testFixed32() {
        let value = WireValue.Fixed32(UInt32.max)
        XCTAssertEqual(value.bytes, [0xFF, 0xFF, 0xFF, 0xFF])
    }
}
class WireValueEquatableTests: XCTestCase {

    func testVarintEqualWithSameValue() {
        let left = WireValue.Varint(UInt64(UInt32.max))
        let right = WireValue.Varint(UInt64(UInt32.max))

        XCTAssert(left == right)
    }

    func testFixed32EqualWithSameValue() {
        let left = WireValue.Fixed32(4)
        let right = WireValue.Fixed32(4)

        XCTAssert(left == right)
    }

    func testFixed32NotEqualWithDifferentValue() {
        let left = WireValue.Fixed32(0)
        let right = WireValue.Fixed32(87)

        XCTAssert(left != right)
    }
}