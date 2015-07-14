//
//  Descriptor.pb.swift
//  StructBuf
//
//  Created by David Paschich on 6/12/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import Foundation

struct FileDescriptorSet: Message {
    var file: [FileDescriptorProto] = []
    var unknownFields: [Int:[WireValue]] = [:]

    var bytes: [UInt8] {
        get {
            var _bytes: [UInt8] = []
            for f in file {
                _bytes.extend(Varint(tag: 1, type: .Bytes).bytes)
                _bytes.extend(try! Varint(value:f.serializedSize).bytes)
                _bytes.extend(f.bytes)
            }
            return _bytes
        }
    }

    init?(bytes: [UInt8]) {
        return nil
    }
}

struct FileDescriptorProto: Message {
    var name: String = ""
    var package: String = ""

    var dependency: [String] = []

    var public_dependency: [Int] = []
    var weak_dependency: [Int] = []

    var message_type: [DescriptorProto] = []
    var enum_type: [EnumDescriptorProto] = []
    var service: [ServiceDescriptorProto] = []

    var extensionField: [FieldDescriptorProto] = []

    var options: FileOptions? = nil

    var sourceCodeInfo: SourceCodeInfo? = nil

    var bytes: [UInt8] { get { return [] } }
    var unknownFields: [Int:[WireValue]] = [:]
    init?(bytes: [UInt8]) {
        return nil
    }
}

struct DescriptorProto {
    var name: String = ""
    var field: [FieldDescriptorProto] = []
    var extensionField: [FieldDescriptorProto] = []

    var nestedType: [DescriptorProto] = []
    var enumType: [EnumDescriptorProto] = []

    struct ExtensionRange {
        var start: Int = 0
        var end: Int = 0
    }
    var extensionRange: [ExtensionRange] = []
    var oneofDecl: [OneofDescriptorProto] = []

    var options: MessageOptions?

    struct ReservedRange {
        var start: Int = 0
        var end: Int = 0
    }
    var reservedRange: [ReservedRange] = []
    var reservedName: [String] = []
}

struct FieldDescriptorProto {
    enum Type: Int {
        case TypeDouble = 1
        case TypeFloat = 2
        case TypeInt64 = 3
        case TypeUint64 = 4
        case TypeInt32 = 5
        case TypeFixed64 = 6
        case TypeFixed32 = 7
        case TypeBool = 8
        case TypeString = 9
        case TypeGroup = 10
        case TypeMessage = 11

        case TypeBytes = 12
        case TypeUint32 = 13
        case TypeEnum = 14
        case TypeSfixed32 = 15
        case TypeSfixed64 = 16
        case TypeSint32 = 17
        case TypeSint64 = 18
    }

    enum Label: Int {
        case LabelOptional = 1
        case LabelRequired = 2
        case LabelRepeated = 3
    }

    var name: String = ""
    var number: Int = 0
    var label: Label = .LabelOptional

    var type: Type = .TypeDouble

    var typeName: String = ""
    var extendee: String = ""

    var defaultValue: String = ""
    var oneofIndex: Int = 0
    var options: FieldOptions?
}

struct OneofDescriptorProto {
    var name: String = ""
}

struct EnumDescriptorProto {
    var name: String = ""
    var value: [EnumValueDescriptorProto] = []
    var options: EnumOptions?
}

struct EnumValueDescriptorProto {
    var name: String = ""
    var number: Int = 0

    var options: EnumValueOptions?
}

struct ServiceDescriptorProto {
    var name: String = ""
    var method: [MethodDescriptorProto] = []
    var options: ServiceOptions?
}

struct MethodDescriptorProto {
    var name: String = ""
    var inputType: String = ""
    var outputType: String = ""

    var options: MethodOptions?

    var clientStreaming: Bool = false
    var serverStreaming: Bool = false
}

struct FileOptions {
    var javaPackage: String = ""
    var javaOuterClassname: String = ""
    var javaMultipleFiles: Bool = false
    var javaGenerateEqualsAndHash: Bool = false
    var javaStringCheckUtf8: Bool = false

    enum OptimizeMode: Int {
        case Speed = 1
        case CodeSize = 2
        case LiteRuntime = 3
    }
    var optimizeFor: OptimizeMode = .Speed

    var goPackage: String = ""

    var ccGenericServices: Bool = false
    var javaGenericServices: Bool = false
    var pyGenericServices: Bool = false

    var deprecated: Bool = false
    var ccEnableArenas: Bool = false
    var objcClassPrefix: String = ""
    var csharpNamespace: String = ""
    var uninterpretedOption: [UninterpretedOption] = []
}

struct MessageOptions {
    var messageSetWireFormat: Bool = false
    var noStandardDescriptorAccessor: Bool = false
    var deprecated: Bool = false
    var mapEntry: Bool = false
    var uninterpretedOption: [UninterpretedOption] = []
}

struct FieldOptions {
    enum CType {
        case String
        case Cord
        case StringPiece
    }
    var ctype: CType = .String

    var packed: Bool = false
    var jstype: JSType = .JsNormal
    enum JSType {
        case JsNormal
        case JsString
        case JsNumber
    }

    var lazy: Bool = false
    var deprecated: Bool = false
    var weak: Bool = false
    var uninterpretedOption: [UninterpretedOption] = []
}

struct EnumOptions {
    var allowAlias: Bool = false
    var deprecated: Bool = false
    var uninterpretedOption: [UninterpretedOption] = []
}

struct EnumValueOptions {
    var deprecated: Bool = false
    var uninterpretedOption: [UninterpretedOption] = []
}

struct ServiceOptions {
    var deprecated: Bool = false
    var uninterpretedOption: [UninterpretedOption] = []
}

struct MethodOptions {
    var deprecated: Bool = false
    var uninterpretedOption: [UninterpretedOption] = []
}

struct UninterpretedOption {
    struct NamePart {
        var namePart: String = ""
        var isExtension: Bool = false
    }
    var name: [NamePart] = []
    var identifierValue: String = ""
    var positiveIntValue: UInt64 = 0
    var negativeIntValue: Int64 = 0
    var doubleValue: Double = 0
    var stringValue: [UInt8] = []
    var aggregateValue: String = ""
}

struct SourceCodeInfo {
    struct Location {
        var path: [Int] = []
        var span: [Int] = []
        var leadingComments: String = ""
        var trailingComments: String = ""
        var leadingDetachedComments: [String] = []
    }
    var location: [Location] = []
}

