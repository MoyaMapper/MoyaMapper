//
//  MMJSONDecodingStorage.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2019/3/19.
//  Copyright © 2019 LXF. All rights reserved.
//

import Foundation

// MARK: - Decoding Storage

struct _MMJSONDecodingStorage {
    // MARK: Properties
    
    /// The container stack.
    /// Elements may be any one of the JSON types (NSNull, NSNumber, String, Array, [String : Any]).
    private(set) var containers: [Any] = []
    
    // MARK: - Initialization
    
    /// Initializes `self` with no containers.
    init() {}
    
    // MARK: - Modifying the Stack
    
    var count: Int {
        return self.containers.count
    }
    
    var topContainer: Any {
        precondition(self.containers.count > 0, "Empty container stack.")
        return self.containers.last!
    }
    
    mutating func push(container: Any) {
        self.containers.append(container)
    }
    
    mutating func popContainer() {
        precondition(self.containers.count > 0, "Empty container stack.")
        self.containers.removeLast()
    }
}
