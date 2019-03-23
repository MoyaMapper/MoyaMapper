//
//  MMJSONDefault.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2019/3/20.
//  Copyright © 2019 LXF. All rights reserved.
//

public protocol MMJSONDefault {
    var boolValue: Bool { get }
    var intValue: Int { get }
    var int8Value: Int8 { get }
    var int16Value: Int16 { get }
    var int32Value: Int32 { get }
    var int64Value: Int64 { get }
    var uIntValue: UInt { get }
    var uInt8Value: UInt8 { get }
    var uInt16Value: UInt16 { get }
    var uInt32Value: UInt32 { get }
    var uInt64Value: UInt64 { get }
    var floatValue: Float { get }
    var doubleValue: Double { get }
    var stringValue: String { get }
}

struct MMDefaultValue {
    static var boolValue: Bool { return false }
    static var intValue: Int { return 0 }
    static var int8Value: Int8 { return 0 }
    static var int16Value: Int16 { return 0 }
    static var int32Value: Int32 { return 0 }
    static var int64Value: Int64 { return 0 }
    static var uIntValue: UInt { return 0 }
    static var uInt8Value: UInt8 { return 0 }
    static var uInt16Value: UInt16 { return 0 }
    static var uInt32Value: UInt32 { return 0 }
    static var uInt64Value: UInt64 { return 0 }
    static var floatValue: Float { return 0 }
    static var doubleValue: Double { return 0 }
    static var stringValue: String { return "" }
}

public struct CustomDefaultValue: MMJSONDefault {
    public var boolValue: Bool { return false }
    public var intValue: Int { return 0 }
    public var int8Value: Int8 { return 0 }
    public var int16Value: Int16 { return 0 }
    public var int32Value: Int32 { return 0 }
    public var int64Value: Int64 { return 0 }
    public var uIntValue: UInt { return 0 }
    public var uInt8Value: UInt8 { return 0 }
    public var uInt16Value: UInt16 { return 0 }
    public var uInt32Value: UInt32 { return 0 }
    public var uInt64Value: UInt64 { return 0 }
    public var floatValue: Float { return 0 }
    public var doubleValue: Double { return 0 }
    public var stringValue: String { return "" }
}
