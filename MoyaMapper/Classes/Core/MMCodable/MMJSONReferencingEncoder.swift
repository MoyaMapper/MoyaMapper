//
//  MMJSONReferencingEncoder.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2019/3/19.
//  Copyright © 2019 LXF. All rights reserved.
//

import Foundation

// MARK: - _JSONReferencingEncoder

/// _JSONReferencingEncoder is a special subclass of _JSONEncoder which has its own storage, but references the contents of a different encoder.
/// It's used in superEncoder(), which returns a new encoder for encoding a superclass -- the lifetime of the encoder should not escape the scope it's created in, but it doesn't necessarily know when it's done being used (to write to the original container).
class _MMJSONReferencingEncoder : _MMJSONEncoder {
    // MARK: Reference types.
    
    /// The type of container we're referencing.
    private enum Reference {
        /// Referencing a specific index in an array container.
        case array(NSMutableArray, Int)
        
        /// Referencing a specific key in a dictionary container.
        case dictionary(NSMutableDictionary, String)
    }
    
    // MARK: - Properties
    
    /// The encoder we're referencing.
    let encoder: _MMJSONEncoder
    
    /// The container reference itself.
    private let reference: Reference
    
    // MARK: - Initialization
    
    /// Initializes `self` by referencing the given array container in the given encoder.
    init(referencing encoder: _MMJSONEncoder, at index: Int, wrapping array: NSMutableArray) {
        self.encoder = encoder
        self.reference = .array(array, index)
        super.init(options: encoder.options, codingPath: encoder.codingPath)
        
        self.codingPath.append(_MMJSONKey(index: index))
    }
    
    /// Initializes `self` by referencing the given dictionary container in the given encoder.
    init(referencing encoder: _MMJSONEncoder,
                     key: CodingKey, convertedKey: CodingKey, wrapping dictionary: NSMutableDictionary) {
        self.encoder = encoder
        self.reference = .dictionary(dictionary, convertedKey.stringValue)
        super.init(options: encoder.options, codingPath: encoder.codingPath)
        
        self.codingPath.append(key)
    }
    
    // MARK: - Coding Path Operations
    
    override var canEncodeNewValue: Bool {
        // With a regular encoder, the storage and coding path grow together.
        // A referencing encoder, however, inherits its parents coding path, as well as the key it was created for.
        // We have to take this into account.
        return self.storage.count == self.codingPath.count - self.encoder.codingPath.count - 1
    }
    
    // MARK: - Deinitialization
    
    // Finalizes `self` by writing the contents of our storage to the referenced encoder's storage.
    deinit {
        let value: Any
        switch self.storage.count {
        case 0: value = NSDictionary()
        case 1: value = self.storage.popContainer()
        default: fatalError("Referencing encoder deallocated with multiple containers on stack.")
        }
        
        switch self.reference {
        case .array(let array, let index):
            array.insert(value, at: index)
            
        case .dictionary(let dictionary, let key):
            dictionary[NSString(string: key)] = value
        }
    }
}
