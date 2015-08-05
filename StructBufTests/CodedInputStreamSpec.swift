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
        it("can yield a fixed32") {
            let stream = CodedInputStream(bytes: [0x0,0x0,0x0,0x0])
            let result = stream.readFixed32Unsigned()
            expect(result).to(equal(0))
        }

        it("returns a generator") {
            do {
                let stream = CodedInputStream(bytes: [])
                _ = try stream.generator()
            } catch {
                XCTFail("should not have thrown")
            }
        }
    }
}
