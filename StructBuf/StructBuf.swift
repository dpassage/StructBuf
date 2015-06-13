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
