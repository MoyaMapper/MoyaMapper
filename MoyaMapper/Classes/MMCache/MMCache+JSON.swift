//
//  MMCache+JSON.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/10/26.
//

import Moya
import SwiftyJSON

// MARK:- JSON
public extension MMCache {
    @discardableResult
    func cacheJSON(
        _ json: JSON,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        switch cacheContainer {
        case .RAM:
            MMCache.shared.jsonRAMStorage.setObject(json, forKey: key)
            return true
        case .hybrid:
            do {
                try MMCache.shared.jsonStorage?.setObject(json, forKey: key)
                return true
            }
            catch {
                return false
            }
        }
    }
    
    func fetchJSONCache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> JSON? {
        switch cacheContainer {
        case .RAM:
            return try? MMCache.shared.jsonRAMStorage.object(forKey: key)
        case .hybrid:
            guard let json = try? MMCache.shared.jsonStorage?.object(forKey: key)
                else {
                    return nil
            }
            return json
        }
    }
    
    @discardableResult
    func removeJSONCache(
        _ key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        switch cacheContainer {
        case .RAM:
            MMCache.shared.jsonRAMStorage.removeObject(forKey: key)
            return true
        case .hybrid:
            do {
                try MMCache.shared.jsonStorage?.removeObject(forKey: key)
                return true
            }
            catch { return false }
        }
    }
    
    @discardableResult
    func removeAllJSONCache(cacheContainer: MMCache.CacheContainer = .RAM) -> Bool {
        switch cacheContainer {
        case .RAM:
            MMCache.shared.jsonRAMStorage.removeAll()
            return true
        case .hybrid:
            do {
                try MMCache.shared.jsonStorage?.removeAll()
                return true
            }
            catch { return false }
        }
    }
}

// MARK:- Supplement
// MARK: Bool
public extension MMCache {
    @discardableResult
    func cacheBool(
        _ value: Bool,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchBoolCache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .boolValue
    }
}

// MARK: Int
public extension MMCache {
    @discardableResult
    func cacheInt(
        _ value: Int,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchIntCache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Int? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .intValue
    }
}

// MARK: Int8
public extension MMCache {
    @discardableResult
    func cacheInt8(
        _ value: Int8,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchInt8Cache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Int8? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .int8Value
    }
}

// MARK: Int16
public extension MMCache {
    @discardableResult
    func cacheInt16(
        _ value: Int16,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchInt16Cache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Int16? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .int16Value
    }
}

// MARK: Int32
public extension MMCache {
    @discardableResult
    func cacheInt32(
        _ value: Int32,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchInt32Cache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Int32? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .int32Value
    }
}

// MARK: Int64
public extension MMCache {
    @discardableResult
    func cacheInt64(
        _ value: Int64,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchInt64Cache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Int64? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .int64Value
    }
}

// MARK: UInt
public extension MMCache {
    @discardableResult
    func cacheUInt(
        _ value: UInt,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchUIntCache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> UInt? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .uIntValue
    }
}

// MARK: UInt8
public extension MMCache {
    @discardableResult
    func cacheUInt8(
        _ value: UInt8,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchUInt8Cache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> UInt8? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .uInt8Value
    }
}

// MARK: UInt16
public extension MMCache {
    @discardableResult
    func cacheUInt16(
        _ value: UInt16,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchUInt16Cache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> UInt16? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .uInt16Value
    }
}

// MARK: UInt32
public extension MMCache {
    @discardableResult
    func cacheUInt32(
        _ value: UInt32,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchUInt32Cache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> UInt32? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .uInt32Value
    }
}

// MARK: UInt64
public extension MMCache {
    @discardableResult
    func cacheUInt64(
        _ value: UInt64,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchInt64Cache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> UInt64? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .uInt64Value
    }
}

// MARK: Float
public extension MMCache {
    @discardableResult
    func cacheFloat(
        _ value: Float,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchFloatCache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Float? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .floatValue
    }
}

// MARK: Double
public extension MMCache {
    @discardableResult
    func cacheDouble(
        _ value: Double,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchDoubleCache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Double? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .doubleValue
    }
}

// MARK: String
public extension MMCache {
    @discardableResult
    func cacheString(
        _ value: String,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        let json = JSON([key : value])
        return cacheJSON(json, key: key, cacheContainer: cacheContainer)
    }
    
    func fetchStringCache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> String? {
        return fetchJSONCache(key: key, cacheContainer: cacheContainer)?
            .dictionaryValue[key]?
            .stringValue
    }
}
