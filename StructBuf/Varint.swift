//
//  Varint.swift
//  ProtocolBuffers
//
//  Created by David Paschich on 6/9/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import Foundation

public struct Varint {
    public let bytes: [UInt8]

    public init(uint64: UInt64) {
        var _bytes: [UInt8] = []
        var _value = uint64
        while (true) {
            if ((_value & ~0x7F) == 0) {
                _bytes.append(UInt8(_value))
                break
            } else {
                _bytes.append(UInt8((_value & 0x7F) | 0x80));
                _value = _value >> 7
            }
        }
        bytes = _bytes
    }

    public init(uint32: UInt32) {
        self.init(uint64: UInt64(uint32))
    }

    public init(value: Int) throws {
        guard value >= 0 else { throw StructBufError.NotImplemented }
        self.init(uint64: UInt64(value))
    }

    init(tag: Int, type: WireType) {
        self.init(uint64: UInt64(tag) << 3 | UInt64(type.rawValue))
    }

    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }

    init(value: Bool) {
        self.bytes = value ? [1] : [0]
    }

    // if successful, returns a tuple of a new Varint followed by
    // the number of bytes consumed.
    public static func fromBytes(bytes: [UInt8]) throws -> (Varint, Int) {
        for i in 0...10 {
            if i >= bytes.count {
                throw StructBufError.ParseFailed
            }
            if bytes[i] & 0x80 == 0 {
                let varint = Varint(bytes: [UInt8](bytes[0...i]))
                return (varint, varint.bytes.count)
            }
        }
        throw StructBufError.ParseFailed
    }

    public func as_bool() -> Bool {
        switch bytes.count {
        case 0:
            return false
        default:
            return (bytes[0] & 0xFF) != 0
        }
    }

    public func asInt() throws -> Int {
        let value = asUInt64()
        if (value > UInt64(Int.max)) {
            throw StructBufError.OutOfRange
        }
        return Int(value)
    }

    public func asUInt64() -> UInt64 {
        var accum: UInt64 = 0
        for b in bytes.reverse() {
            accum = UInt64(b & 0x7f) + (accum << 7)
        }
        return accum
    }
}
