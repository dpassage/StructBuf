//: ## Protobufs in Swift
//:
//: I've been using Google's protocol buffers for a project at work recently,
//: where we need to support cross-platform communications over a socket. We're
//: using Square's Wire library for the Java side, and Alexey Khokhlov's
//: protobuf-swift on the iOS side.
//:
//: Alexey's code is working well for us, but there are lots of places where it
//: doesn't feel as "Swift"-y as it could. For instance, messages feel like they
//: should be immutable `struct`s, not `class`es.
//:
//: This playground is an exploration of what a minimalist implementation in
//: Swift could look like. I'm focused here on compactness of code and using
//: Swift idioms. This includes just the runtime code, not the protobuf compiler
//: code to generate it.


import Foundation

//: First, a few enums for data types. The first represents all the semantic
//: types for parameters in a protobuf, and maps them to the analogous Swift
//: native type. I'm abusing convention and using all lower-case for the cases
//: in the enum, so as to avoid name collisions with the Swift native type
//: names, as well as to mirror the `.proto` file syntax.
enum ProtoBufValue {
    case double(Double)
    case float(Float)
    case int32(Int32)
    case int64(Int64)
    case uint32(UInt32)
    case uint64(UInt64)
    case sint32(Int32)
    case sint64(Int64)
    case fixed32(UInt32)
    case fixed64(UInt64)
    case sfixed32(Int32)
    case sfixed64(Int64)
    case bool(Bool)
    case string(String) //Always UTF-8 encoded on the wire
    case bytes([UInt8])
    case message(Message)
}

//: Next, enums for the wire types. One defines the legal tag numbers; the
//: next has the values.
enum WireType: Int {
    case Varint = 0
    case Fixed64 = 1
    case Bytes = 2
    case StartGroup = 3
    case EndGroup = 4
    case Fixed32 = 5
}

enum WireValue {
    case Varint(UInt64)
    case Fixed64(UInt64)
    case Bytes([UInt8])
    case StartGroup
    case EndGroup
    case Fixed32(UInt32)

    var type: WireType {
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

//: Let's try this. Converts numeric values into the byte-streamed varint
//: implementation.
struct Varint {
    let bytes: [UInt8]

    init(value: UInt64) {
        var _bytes: [UInt8] = []
        var _value = value
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

    init(value: UInt32) {
        self.init(value: UInt64(value))
    }

    init(value: Int) {
        self.init(value: UInt64(value))
    }

    init(tag: Int, type: WireType) {
        self.init(value: UInt64(tag) << 3 | UInt64(type.rawValue))
    }

    init(bytes: [UInt8]) {
        self.bytes = bytes
    }

    init(value: Bool) {
        self.bytes = value ? [1] : [0]
    }

    // if successful, returns a tuple of a new Varint followed by
    // the number of bytes consumed.
    static func fromBytes(bytes: [UInt8]) -> (Varint, Int)? {
        for i in 0...10 {
            if bytes[i] & 0x80 == 0 {
                let varint = Varint(bytes: [UInt8](bytes[0...i]))
                return (varint, varint.bytes.count)
            }
        }
        return nil
    }

    func as_bool() -> Bool {
        switch bytes.count {
        case 0:
            return false
        default:
            return (bytes[0] & 1) == 1
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

//: Represents a single field as read from the wire
struct Field {
    let tag: Int
    let value: WireValue
}

//: Class for parsing buffers from the wire.
//: Takes a sequence of UInt8s to initialize; it's a Generator yielding
//: a sequence of Fields.

struct FieldGenerator: GeneratorType {
    typealias Element = Field
    mutating func next() -> Field? {
        return nil
    }

//    init(byteSequence: )
}

struct FieldSequence: SequenceType {
    typealias Generator = FieldGenerator

    func generate() -> Generator {
        return FieldGenerator()
    }
}

class ParseWireFormat {
    var byteSquence: AnySequence<UInt8>

    init(bytes: [UInt8]) {
        byteSquence = AnySequence(bytes)
    }

    func nextField() -> (WireValue, Int)? {
        // read a varint
        // split into tag and type
        // read the type, build wirevalue
        
//        var fieldLabel: Varint
//        var bytesUsed: Int
//        if let (fieldLabel, bytesUsed) = Varint.fromBytes(bytes) {
//
//        }
//
        return nil
    }
}

//: Now we have a couple of protocols for the `Message` and `Builder` types.
//: Because Swift `struct`s don't support inheritance, we probably want to keep
//: these minimal.
protocol Message {
    var bytes: [UInt8] { get }
    var serializedSize: Int { get }
    var unknownFields: [Int:[WireValue]] { get }
    init?([UInt8])
}

protocol Builder {
    typealias M: Message

    var isValid: Bool { get }
    func addTag(tag: Int, value: WireValue)
    func build() -> M?
}

enum StructBufError {
    case ParseFailed
}

//: Now, here's one of the example bufs from Google's documentation
/*
enum PhoneType {
MOBILE = 0;
HOME = 1;
WORK = 2;
}

message PhoneNumber {
required string number = 1;
optional PhoneType type = 2 [default = HOME];
}
*/

enum PhoneType {
    case Mobile
    case Home
    case Work
    case Unknown(Int)

    var rawValue: Int {
         switch self {
        case .Mobile:
            return 0
        case .Home:
            return 1
        case .Work:
            return 2
        case let .Unknown(value):
            return value
        }
    }
    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .Mobile
        case 1:
            self = .Home
        case 2:
            self = .Work
        default:
            self = .Unknown(rawValue)
        }
    }

    var bytes: [UInt8] {
        return Varint(value: 1).bytes + Varint(value: rawValue).bytes
    }
}

var foo: PhoneType = .Unknown(4)
print(foo.rawValue)

//var bar = PhoneType(rawValue: 32)
//bar?.hashValue


struct PhoneNumber: Message {
    var number: String
    var type: PhoneType
    var unknownFields: [Int:[WireValue]]

    var bytes: [UInt8] {
        get {
            var _bytes = [UInt8]()
            _bytes += Varint(tag: 1, type: .Bytes).bytes
            let numberBytes = [UInt8](number.utf8)
            _bytes += Varint(value: numberBytes.count).bytes
            _bytes += numberBytes
                _bytes += Varint(tag: 2, type: .Varint).bytes
                _bytes += Varint(value: type.rawValue).bytes
            for (tag, values) in unknownFields {
                for value in values {
                    _bytes += Varint(tag: tag, type: value.type).bytes
                    _bytes += value.bytes
                }
            }
            return _bytes
        }
    }

    var serializedSize: Int { get { return bytes.count } }

    mutating func addTag(tag: Int, value: WireValue) {
        switch tag {
        case 1:
            switch value {
            case .Bytes(let bytes):
                number = (NSString(bytes: bytes, length: bytes.count, encoding: NSUTF8StringEncoding) as? String)!
            default:
                break
            }
        case 2:
            switch value {
            case .Varint(let phoneType):
                type = PhoneType(rawValue: Int(phoneType))
            default:
                break
            }
        default:
            if unknownFields[tag] == nil {
                unknownFields[tag] = [value]
            } else {
                unknownFields[tag]!.append(value)
            }
        }
    }

    init?(_: [UInt8]) { return nil }
    init(number: String, type: PhoneType = .Home, unknownFields: [Int:[WireValue]] = [:]) {
        self.number = number
        self.type = type
        self.unknownFields = unknownFields
    }
}


//let number: PhoneNumber = PhoneNumberBuilder().setNumber("Foo").setType(.HOME).build()!
let number = PhoneNumber(number: "Foo", type: .Home)
let theBytes = number.bytes
number.serializedSize

let newNumber = PhoneNumber(theBytes)
newNumber

