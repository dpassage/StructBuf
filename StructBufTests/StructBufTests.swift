//
//  StructBufTests.swift
//  StructBufTests
//
//  Created by David Paschich on 6/11/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import XCTest
@testable import StructBuf

class StructBufTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}

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