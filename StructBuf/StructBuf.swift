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
    case OutOfRange
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
    case VarintEncoded(UInt64)
    case Fixed64(UInt64)
    case Bytes([UInt8])
    case StartGroup
    case EndGroup
    case Fixed32(UInt32)

    public var type: WireType {
        get {
            switch self {
            case .VarintEncoded(_):
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
            case let .VarintEncoded(value):
                let varint = Varint(uint64 :value)
                return varint.bytes
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
                var bytes = Varint(uint64: UInt64(value.count)).bytes
                bytes.extend(value)
                return bytes
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
}

extension WireValue: Equatable {}
public func ==(left: WireValue, right: WireValue) -> Bool {
    switch (left, right) {
    case (.Fixed32(let leftValue), .Fixed32(let rightValue)):
        return leftValue == rightValue
    case (.VarintEncoded(let leftvalue), .VarintEncoded(let rightvalue)):
        return leftvalue == rightvalue
//    case let .Fixed64(value):
//        return right == WireValue.Fixed64(value)
//    case let .Bytes(value):
//        return right == WireValue.Bytes(value)
//    case .StartGroup:
//        return right == .StartGroup
//    case .EndGroup:
//        return right == .EndGroup
    default:
        return false
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
        var totalBytesRead = 0
        let (varint, bytesRead) = try Varint.fromBytes(bytes)
        totalBytesRead += bytesRead
        let number = try varint.asInt()
        let tag = number >> 3
        guard let type = WireType(rawValue: number & 0x7) else { throw StructBufError.ParseFailed }

        switch type {
        case .Varint:
            let valueBytes = [UInt8](bytes[totalBytesRead..<bytes.count])
            let (varintValue, varintBytes) = try Varint.fromBytes(valueBytes)
            totalBytesRead += varintBytes
            return (Field(number: tag, value: WireValue.VarintEncoded(varintValue.asUInt64())), totalBytesRead)
        case .Fixed32:
            var value: UInt32 = 0
            guard bytes.count >= totalBytesRead + 4 else { throw StructBufError.ParseFailed }
            for i in totalBytesRead..<(totalBytesRead + 4) {
                value = (value << 8) + UInt32(bytes[i])
            }
            return (Field(number: tag, value: WireValue.Fixed32(value)), totalBytesRead + 4)
        default:
            throw StructBufError.NotImplemented
        }
    }
}
