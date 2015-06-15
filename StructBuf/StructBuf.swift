//
//  StructBuf.swift
//  StructBuf
//
//  Created by David Paschich on 6/11/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import Foundation

public enum StructBufError: ErrorType {
    case ParseFailed
    case NotImplemented
}

public enum WireType: Int {
    case Varint = 0
    case Fixed64 = 1
    case Bytes = 2
    case StartGroup = 3
    case EndGroup = 4
    case Fixed32 = 5
}

public enum WireValue {
    case Varint(UInt64)
    case Fixed64(UInt64)
    case Bytes([UInt8])
    case StartGroup
    case EndGroup
    case Fixed32(UInt32)

    public var type: WireType {
        get {
            switch self {
            case .Varint(_):
                return WireType.Varint
            case .Fixed64(_):
                return WireType.Fixed64
            case .Bytes(_):
                return WireType.Bytes
            case .StartGroup:
                return WireType.StartGroup
            case .EndGroup:
                return WireType.EndGroup
            case .Fixed32(_):
                return WireType.Fixed32
            }
        }
    }
}

//: Because Swift `enum`s can have methods, we have a convenient place to
//: put serialization code.
extension WireValue {
    var bytes: [UInt8] {
        get {
            switch self {
            case let .Varint(value):
                return Varint(value).bytes
            case let .Fixed64(value):
                return [
                    UInt8( value        & 0xFF),
                    UInt8((value >>  8) & 0xFF),
                    UInt8((value >> 16) & 0xFF),
                    UInt8((value >> 24) & 0xFF),
                    UInt8((value >> 32) & 0xFF),
                    UInt8((value >> 40) & 0xFF),
                    UInt8((value >> 48) & 0xFF),
                    UInt8((value >> 56) & 0xFF)
                ]
            case let .Bytes(value):
                return Varint(UInt64(value.count)).bytes + value
            case .StartGroup:
                fallthrough
            case .EndGroup:
                return []
            case let .Fixed32(value):
                return [
                    UInt8( value        & 0xFF),
                    UInt8((value >>  8) & 0xFF),
                    UInt8((value >> 16) & 0xFF),
                    UInt8((value >> 24) & 0xFF)
                ]
            }
        }
    }
    var byteCount: Int {
        get { return bytes.count }
    }
}

extension WireValue: Equatable {}
public func ==(left: WireValue, right: WireValue) -> Bool {
    switch left {
    case let .Varint(value):
        return right == WireValue.Varint(value)
    case let .Fixed64(value):
        return right == WireValue.Fixed64(value)
    case let .Bytes(value):
        return right == WireValue.Bytes(value)
    case .StartGroup:
        return right == .StartGroup
    case .EndGroup:
        return right == .EndGroup
    case let .Fixed32(value):
        return right == .Fixed32(value)
    }
}

public struct Field {
    var number: Int
    var value: WireValue

    var bytes: [UInt8] {
        return Varint(tag: number, type: value.type).bytes +
        value.bytes
    }

    static func fromBytes(bytes: [UInt8]) throws -> (Field, Int) {
        throw StructBufError.NotImplemented
//        let (varint, bytesRead) = try Varint.fromBytes(bytes)
//        let number = varint.
    }
}
