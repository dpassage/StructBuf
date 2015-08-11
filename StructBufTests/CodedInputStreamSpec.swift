//
//  CodedInputStreamSpec.swift
//  StructBuf
//
//  Created by David Paschich on 8/4/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import Quick
import Nimble

@testable import StructBuf

class CodedInputStreamSpec: QuickSpec {

    override func spec() {
        describe("Fixed32") {
            it("can yield a fixed32") {
                let stream = CodedInputStream(bytes: [0x0,0x0,0x0,0x0])
                let result = try! stream.readFixed32Unsigned()
                expect(result).to(equal(0))
            }

            it("can correctly yield a random number") {
                for _ in 0...1 {
                    let number = arc4random()
                    let bytes = [UInt8(number & 0xff),
                                 UInt8((number >> 8) & 0xff),
                                 UInt8((number >> 16) & 0xff),
                                 UInt8((number >> 24) & 0xff)]
                    let stream = CodedInputStream(bytes: bytes)
                    let result = try! stream.readFixed32Unsigned()
                    expect(result).to(equal(number))
                }
            }

            it("throws when not enough bytes") {
                let bytes: [UInt8] = [0x11, 0x37]
                let stream = CodedInputStream(bytes: bytes)
                do {
                    try _ = stream.readFixed32Unsigned()
                } catch StructBufError.ParseFailed {
                    // passed
                    return
                } catch {
                    XCTFail("threw wrong error")
                }
                XCTFail("should have thrown")
            }
        }

//        it("returns a generator") {
//            do {
//                let stream = CodedInputStream(bytes: [])
//                let _ = try stream.generator()
//            } catch {
//                XCTFail("should not have thrown")
//            }
//        }
    }
}
