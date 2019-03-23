//
//  MMJSONDecoder+SingleValueDecodingContainer.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2019/3/19.
//  Copyright © 2019 LXF. All rights reserved.
//

import Foundation

extension _MMJSONDecoder : SingleValueDecodingContainer {
    // MARK: SingleValueDecodingContainer Methods
    
    private func expectNonNull<T>(_ type: T.Type) throws {
        guard !self.decodeNil() else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected \(type) but found null value instead."))
        }
    }
    
    public func decodeNil() -> Bool {
        return self.storage.topContainer is NSNull
    }
    
    public func decode(_ type: Bool.Type) throws -> Bool {
        // try expectNonNull(Bool.self)
        guard let value = try self.unbox(self.storage.topContainer, as: Bool.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.boolValue
            case let .customDefaultValue(custom):
                return custom.boolValue
            }
        }
        return value
    }
    
    public func decode(_ type: Int.Type) throws -> Int {
        // try expectNonNull(Int.self)
        guard let value = try self.unbox(self.storage.topContainer, as: Int.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.intValue
            case let .customDefaultValue(custom):
                return custom.intValue
            }
        }
        return value
    }
    
    public func decode(_ type: Int8.Type) throws -> Int8 {
        // try expectNonNull(Int8.self)
        guard let value = try self.unbox(self.storage.topContainer, as: Int8.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int8Value
            case let .customDefaultValue(custom):
                return custom.int8Value
            }
        }
        return value
    }
    
    public func decode(_ type: Int16.Type) throws -> Int16 {
        // try expectNonNull(Int16.self)
        guard let value = try self.unbox(self.storage.topContainer, as: Int16.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int16Value
            case let .customDefaultValue(custom):
                return custom.int16Value
            }
        }
        return value
    }
    
    public func decode(_ type: Int32.Type) throws -> Int32 {
        // try expectNonNull(Int32.self)
        guard let value = try self.unbox(self.storage.topContainer, as: Int32.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int32Value
            case let .customDefaultValue(custom):
                return custom.int32Value
            }
        }
        return value
    }
    
    public func decode(_ type: Int64.Type) throws -> Int64 {
        // try expectNonNull(Int64.self)
        guard let value = try self.unbox(self.storage.topContainer, as: Int64.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int64Value
            case let .customDefaultValue(custom):
                return custom.int64Value
            }
        }
        return value
    }
    
    public func decode(_ type: UInt.Type) throws -> UInt {
        // try expectNonNull(UInt.self)
        guard let value = try self.unbox(self.storage.topContainer, as: UInt.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uIntValue
            case let .customDefaultValue(custom):
                return custom.uIntValue
            }
        }
        return value
    }
    
    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        // try expectNonNull(UInt8.self)
        guard let value = try self.unbox(self.storage.topContainer, as: UInt8.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt8Value
            case let .customDefaultValue(custom):
                return custom.uInt8Value
            }
        }
        return value
    }
    
    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        // try expectNonNull(UInt16.self)
        guard let value = try self.unbox(self.storage.topContainer, as: UInt16.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt16Value
            case let .customDefaultValue(custom):
                return custom.uInt16Value
            }
        }
        return value
    }
    
    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        // try expectNonNull(UInt32.self)
        guard let value = try self.unbox(self.storage.topContainer, as: UInt32.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt32Value
            case let .customDefaultValue(custom):
                return custom.uInt32Value
            }
        }
        return value
    }
    
    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        // try expectNonNull(UInt64.self)
        guard let value = try self.unbox(self.storage.topContainer, as: UInt64.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt64Value
            case let .customDefaultValue(custom):
                return custom.uInt64Value
            }
        }
        return value
    }
    
    public func decode(_ type: Float.Type) throws -> Float {
        // try expectNonNull(Float.self)
        guard let value = try self.unbox(self.storage.topContainer, as: Float.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.floatValue
            case let .customDefaultValue(custom):
                return custom.floatValue
            }
        }
        return value
    }
    
    public func decode(_ type: Double.Type) throws -> Double {
        // try expectNonNull(Double.self)
        guard let value = try self.unbox(self.storage.topContainer, as: Double.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.doubleValue
            case let .customDefaultValue(custom):
                return custom.doubleValue
            }
        }
        return value
    }
    
    public func decode(_ type: String.Type) throws -> String {
        // try expectNonNull(String.self)
        guard let value = try self.unbox(self.storage.topContainer, as: String.self) else {
            switch options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.stringValue
            case let .customDefaultValue(custom):
                return custom.stringValue
            }
        }
        return value
    }
    
    public func decode<T : Decodable>(_ type: T.Type) throws -> T {
        try expectNonNull(type)
        return try self.unbox(self.storage.topContainer, as: type)!
    }
}
