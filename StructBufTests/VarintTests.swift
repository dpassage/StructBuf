//
//  VarintTests.swift
//  ProtocolBuffers
//
//  Created by David Paschich on 6/9/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import XCTest
import StructBuf

class VarintTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitUInt64() {
        let number: UInt64 = 0
        let varint = Varint(uint64: number)

        XCTAssert(varint.bytes.count > 0)
    }

    func testInitUInt64LargeNumber() {
        let number: UInt64 = 10121342435
        let varint = Varint(uint64: number)

        XCTAssert(varint.bytes.count > 0)
    }

    func testInitUInt32() {
        let number: UInt32 = 42
        let varint = Varint(uint32: number)

        XCTAssertGreaterThan(varint.bytes.count, 0)
    }

    func testInitInt() {
        do {
            let number: Int = 1
            let varint = try Varint(value: number)

            XCTAssertGreaterThan(varint.bytes.count, 0)
        } catch {
            XCTFail("should not have thrown error")
        }
    }

//    func testInitIntNegativeNumber() {
//        let number: Int = -4
//        do {
//            _ = try Varint(value: number)
//        } catch StructBufError.NotImplemented {
//            return // test passes
//        } catch {
//            XCTFail("threw wrong error")
//        }
//        XCTFail("should have thrown error")
//    }

    func testTooShortVarintThrows() {
        let inputBytes: [UInt8] = [0x80]

        do {
            _ = try Varint.fromBytes(inputBytes)
        } catch StructBufError.ParseFailed {
            // test passed, return
            return
        } catch {
            XCTFail("wrong error thrown")
        }
        XCTFail("parse should have vailed")
    }

    func testSingleByteInt() {
        let inputBytes: [UInt8] = [0x01]

        do {
            let (_, bytesConsumed) = try Varint.fromBytes(inputBytes)
            XCTAssertEqual(bytesConsumed, 1)

        } catch {
            XCTFail("should not have thrown")
        }

    }

    func testTooManyBytes() {
        let inputBytes = Array<UInt8>(count: 11, repeatedValue: 0x80)

        do {
            _ = try Varint.fromBytes(inputBytes)
        } catch {
            // test passed, return
            return
        }
        XCTFail("parse should have vailed")
    }

    func testAsBool() {
        do {
            let varint = try Varint(value: 40)
            XCTAssertTrue(varint.as_bool())
        } catch {
            XCTFail("should not have thrown")
        }
    }

    func testAsBoolNoBytes() {
        let varint = Varint(bytes: [])
        XCTAssertFalse(varint.as_bool())
    }

    func testAsInt() {
        let varint = try! Varint(value: 4)
        let value = try! varint.asInt()
        XCTAssertEqual(4, value)
    }
}
