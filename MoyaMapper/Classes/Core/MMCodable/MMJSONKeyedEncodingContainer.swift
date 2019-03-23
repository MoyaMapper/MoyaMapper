//
//  MMJSONKeyedEncodingContainer.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2019/3/19.
//  Copyright © 2019 LXF. All rights reserved.
//

import Foundation

// MARK: - Encoding Containers

struct _MMJSONKeyedEncodingContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
    typealias Key = K
    
    // MARK: Properties
    
    /// A reference to the encoder we're writing to.
    private let encoder: _MMJSONEncoder
    
    /// A reference to the container we're writing to.
    private let container: NSMutableDictionary
    
    /// The path of coding keys taken to get to this point in encoding.
    private(set) public var codingPath: [CodingKey]
    
    // MARK: - Initialization
    
    /// Initializes `self` with the given references.
    init(referencing encoder: _MMJSONEncoder, codingPath: [CodingKey], wrapping container: NSMutableDictionary) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.container = container
    }
    
    // MARK: - Coding Path Operations
    
    private func _converted(_ key: CodingKey) -> CodingKey {
        switch encoder.options.keyEncodingStrategy {
        case .useDefaultKeys:
            return key
        case .convertToSnakeCase:
            let newKeyString = MMJSONEncoder.KeyEncodingStrategy._convertToSnakeCase(key.stringValue)
            return _MMJSONKey(stringValue: newKeyString, intValue: key.intValue)
        case .custom(let converter):
            return converter(codingPath + [key])
        }
    }
    
    // MARK: - KeyedEncodingContainerProtocol Methods
    
    public mutating func encodeNil(forKey key: Key) throws {
        self.container[_converted(key).stringValue] = NSNull()
    }
    public mutating func encode(_ value: Bool, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: Int, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: Int8, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: Int16, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: Int32, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: Int64, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: UInt, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: UInt8, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: UInt16, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: UInt32, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: UInt64, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    public mutating func encode(_ value: String, forKey key: Key) throws {
        self.container[_converted(key).stringValue] = self.encoder.box(value)
    }
    
    public mutating func encode(_ value: Float, forKey key: Key) throws {
        // Since the float may be invalid and throw, the coding path needs to contain this key.
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        self.container[_converted(key).stringValue] = try self.encoder.box(value)
    }
    
    public mutating func encode(_ value: Double, forKey key: Key) throws {
        // Since the double may be invalid and throw, the coding path needs to contain this key.
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        self.container[_converted(key).stringValue] = try self.encoder.box(value)
    }
    
    public mutating func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        self.container[_converted(key).stringValue] = try self.encoder.box(value)
    }
    
    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let dictionary = NSMutableDictionary()
        self.container[_converted(key).stringValue] = dictionary
        
        self.codingPath.append(key)
        defer { self.codingPath.removeLast() }
        
        let container = _MMJSONKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath, wrapping: dictionary)
        return KeyedEncodingContainer(container)
    }
    
    public mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let array = NSMutableArray()
        self.container[_converted(key).stringValue] = array
        
        self.codingPath.append(key)
        defer { self.codingPath.removeLast() }
        return _MMJSONUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath, wrapping: array)
    }
    
    public mutating func superEncoder() -> Encoder {
        return _MMJSONReferencingEncoder(referencing: self.encoder, key: _MMJSONKey.super, convertedKey: _converted(_MMJSONKey.super), wrapping: self.container)
    }
    
    public mutating func superEncoder(forKey key: Key) -> Encoder {
        return _MMJSONReferencingEncoder(referencing: self.encoder, key: key, convertedKey: _converted(key), wrapping: self.container)
    }
}
