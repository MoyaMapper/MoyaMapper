//
//  MMJSONDecoder+JSONKeyedDecodingContainer.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2019/3/19.
//  Copyright © 2019 LXF. All rights reserved.
//

import Foundation

// MARK: Decoding Containers

struct _MMJSONKeyedDecodingContainer<K : CodingKey> : KeyedDecodingContainerProtocol {
    typealias Key = K
    
    // MARK: Properties
    
    /// A reference to the decoder we're reading from.
    private let decoder: _MMJSONDecoder
    
    /// A reference to the container we're reading from.
    private let container: [String : Any]
    
    /// The path of coding keys taken to get to this point in decoding.
    private(set) public var codingPath: [CodingKey]
    
    // MARK: - Initialization
    
    /// Initializes `self` by referencing the given decoder and container.
    init(referencing decoder: _MMJSONDecoder, wrapping container: [String : Any]) {
        self.decoder = decoder
        switch decoder.options.keyDecodingStrategy {
        case .useDefaultKeys:
            self.container = container
        case .convertFromSnakeCase:
            // Convert the snake case keys in the container to camel case.
            // If we hit a duplicate key after conversion, then we'll use the first one we saw. Effectively an undefined behavior with JSON dictionaries.
            self.container = Dictionary(container.map {
                dict in (MMJSONDecoder.KeyDecodingStrategy._convertFromSnakeCase(dict.key), dict.value)
            }, uniquingKeysWith: { (first, _) in first })
        case .custom(let converter):
            self.container = Dictionary(container.map {
                key, value in (converter(decoder.codingPath + [_MMJSONKey(stringValue: key, intValue: nil)]).stringValue, value)
            }, uniquingKeysWith: { (first, _) in first })
        }
        self.codingPath = decoder.codingPath
    }
    
    // MARK: - KeyedDecodingContainerProtocol Methods
    
    public var allKeys: [Key] {
        return self.container.keys.compactMap { Key(stringValue: $0) }
    }
    
    public func contains(_ key: Key) -> Bool {
        return self.container[key.stringValue] != nil
    }
    
    private func _errorDescription(of key: CodingKey) -> String {
        switch decoder.options.keyDecodingStrategy {
        case .convertFromSnakeCase:
            // In this case we can attempt to recover the original value by reversing the transform
            let original = key.stringValue
            let converted = MMJSONEncoder.KeyEncodingStrategy._convertToSnakeCase(original)
            if converted == original {
                return "\(key) (\"\(original)\")"
            } else {
                return "\(key) (\"\(original)\"), converted to \(converted)"
            }
        default:
            // Otherwise, just report the converted string
            return "\(key) (\"\(key.stringValue)\")"
        }
    }
    
    public func decodeNil(forKey key: Key) throws -> Bool {
        guard let entry = self.container[key.stringValue] else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
        }
        
        return entry is NSNull
    }
    
    public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.boolValue
            case let .customDefaultValue(custom):
                return custom.boolValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Bool.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.boolValue
            case let .customDefaultValue(custom):
                return custom.boolValue
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.intValue
            case let .customDefaultValue(custom):
                return custom.intValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.intValue
            case let .customDefaultValue(custom):
                return custom.intValue
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return Int8(MMDefaultValue.int8Value)
            case let .customDefaultValue(custom):
                return custom.int8Value
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int8.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int8Value
            case let .customDefaultValue(custom):
                return custom.int8Value
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int16Value
            case let .customDefaultValue(custom):
                return custom.int16Value
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int16.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int16Value
            case let .customDefaultValue(custom):
                return custom.int16Value
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int32Value
            case let .customDefaultValue(custom):
                return custom.int32Value
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int32.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int32Value
            case let .customDefaultValue(custom):
                return custom.int32Value
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int64Value
            case let .customDefaultValue(custom):
                return custom.int64Value
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int64.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.int64Value
            case let .customDefaultValue(custom):
                return custom.int64Value
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uIntValue
            case let .customDefaultValue(custom):
                return custom.uIntValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uIntValue
            case let .customDefaultValue(custom):
                return custom.uIntValue
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt8Value
            case let .customDefaultValue(custom):
                return custom.uInt8Value
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt8.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt8Value
            case let .customDefaultValue(custom):
                return custom.uInt8Value
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt16Value
            case let .customDefaultValue(custom):
                return custom.uInt16Value
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt16.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt16Value
            case let .customDefaultValue(custom):
                return custom.uInt16Value
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt32Value
            case let .customDefaultValue(custom):
                return custom.uInt32Value
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt32.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt32Value
            case let .customDefaultValue(custom):
                return custom.uInt32Value
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt64Value
            case let .customDefaultValue(custom):
                return custom.uInt64Value
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt64.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.uInt64Value
            case let .customDefaultValue(custom):
                return custom.uInt64Value
            }
        }
        
        return value
    }
    
    public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.floatValue
            case let .customDefaultValue(custom):
                return custom.floatValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Float.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.floatValue
            case let .customDefaultValue(custom):
                return custom.floatValue
            }
        }
        
        return value
    }
    
    public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.doubleValue
            case let .customDefaultValue(custom):
                return custom.doubleValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Double.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.doubleValue
            case let .customDefaultValue(custom):
                return custom.doubleValue
            }
        }
        
        return value
    }
    
    public func decode(_ type: String.Type, forKey key: Key) throws -> String {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.stringValue
            case let .customDefaultValue(custom):
                return custom.stringValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: String.self) else {
            switch decoder.options.notFoundKeyOrValueDecodingStrategy {
            case .MMDefaultValue:
                return MMDefaultValue.stringValue
            case let .customDefaultValue(custom):
                return custom.stringValue
            }
        }
        
        return value
    }
    
    public func decode<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        guard let entry = self.container[key.stringValue] else {
            return try safeDecodeOtherType(type, forKey: key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: type) else {
            return try safeDecodeOtherType(type, forKey: key)
        }
        
        return value
    }
    
    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            return safeNestedContainer()
        }
        
        guard let dictionary = value as? [String : Any] else {
            return safeNestedContainer()
        }
        
        let container = _MMJSONKeyedDecodingContainer<NestedKey>(referencing: self.decoder, wrapping: dictionary)
        return KeyedDecodingContainer(container)
    }
    
    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            return safeNestedUnkeyedContainer()
        }
        
        guard let array = value as? [Any] else {
            return safeNestedUnkeyedContainer()
        }
        
        return _MMJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
    }
    
    private func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        let value: Any = self.container[key.stringValue] ?? NSNull()
        return _MMJSONDecoder(referencing: value, at: self.decoder.codingPath, options: self.decoder.options)
    }
    
    public func superDecoder() throws -> Decoder {
        return try _superDecoder(forKey: _MMJSONKey.super)
    }
    
    public func superDecoder(forKey key: Key) throws -> Decoder {
        return try _superDecoder(forKey: key)
    }
}

/// 安全解析相关
extension _MMJSONKeyedDecodingContainer {
    func safeDecodeOtherType<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        if let objectValue = try? MMJSONDecoder().decode(type, from: "{}".data(using: .utf8)!) {
            return objectValue
        } else if let arrayValue = try? MMJSONDecoder().decode(type, from: "[]".data(using: .utf8)!) {
            return arrayValue
        }
        throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
    }
    
    func safeNestedContainer<NestedKey>() -> KeyedDecodingContainer<NestedKey> {
        let container = _MMJSONKeyedDecodingContainer<NestedKey>(referencing: decoder, wrapping: [:])
        return KeyedDecodingContainer(container)
    }
    
    func safeNestedUnkeyedContainer() -> UnkeyedDecodingContainer {
        return _MMJSONUnkeyedDecodingContainer(referencing: decoder, wrapping: [])
    }
}
