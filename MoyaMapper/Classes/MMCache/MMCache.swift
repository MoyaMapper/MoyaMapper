//
//  MMCache.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/9/26.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import Cache
import Moya
import SwiftyJSON

fileprivate struct CacheName {
    static let MoyaResponse = "Cache.lxf.MoyaResponse"
    static let JSON = "Cache.lxf.JSON"
}

public struct MMCache {
    public static let shared = MMCache()
    private init() {}
    
    /**
     let cacheKey = [method]baseURL/path
     
     - default : cacheKey + "?" + parameters
     - base : cacheKey
     - custom : cacheKey + "?" + customKey
     */
    public enum CacheKeyType {
        case `default`
        case base
        case custom(String)
    }
    
    private let boolRAMStorage = MemoryStorage<Bool>(config: MemoryConfig())
    private let jsonRAMStorage = MemoryStorage<JSON>(config: MemoryConfig())
    
    private let responseStorage = try? Storage<Moya.Response>(
        diskConfig: DiskConfig(name: CacheName.MoyaResponse),
        memoryConfig: MemoryConfig(),
        transformer: TransformerFactory.forResponse(Moya.Response.self)
    )
    
    private let jsonStorage = try? Storage<JSON>(
        diskConfig: DiskConfig(name: CacheName.JSON),
        memoryConfig: MemoryConfig(),
        transformer: TransformerFactory.forJSON()
    )
}

// MARK:- MMCache MemoryStorage
extension MMCache {
    func isNoRecord(_ target: TargetType, autoRecord: Bool = true, cacheType: CacheKeyType = .default) -> Bool {
        let isNoRecord = (try? MMCache.shared.boolRAMStorage.object(forKey: target.fetchCacheKey(cacheType))) ?? false
        if autoRecord && !isNoRecord {
            MMCache.shared.record(target)
        }
        return !isNoRecord
    }
    
    func record(_ target: TargetType, cacheType: CacheKeyType = .default) {
        MMCache.shared.boolRAMStorage.setObject(true, forKey: target.fetchCacheKey(cacheType))
    }
}

// MARK:- MMCache HybridStorage
// MARK: Moya.Response
public extension MMCache {
    @discardableResult
    func cacheResponse(_ response: Moya.Response, target: TargetType, cacheType: CacheKeyType = .default) -> Bool {
        do {
            try MMCache.shared.responseStorage?.setObject(response, forKey: target.fetchCacheKey(cacheType))
            let mp = MMResponseParameter(response.lxf_modelableParameter)
            mp.cache(key: target.cacheParameterTypeKey)
            try MMCache.shared.jsonStorage?.setObject(mp.toJSON(), forKey: target.cacheParameterTypeKey)
            return true
        }
        catch { return false }
    }
    func fetchResponseCache(target: TargetType, cacheType: CacheKeyType = .default) -> Moya.Response? {
        guard let response = try? MMCache.shared.responseStorage?.object(forKey: target.fetchCacheKey(cacheType))
        else { return nil }
        
        guard let json = try? MMCache.shared.jsonStorage?.object(forKey: target.cacheParameterTypeKey)
        else { return nil }
        
        guard let mp = json?.modelValue(MMResponseParameter.self)
        else { return nil }
        
        response?.setNetParameter(TemplateParameter(
            successValue: mp.successValue,
            statusCodeKey: mp.statusCodeKey,
            tipStrKey: mp.tipStrKey,
            modelKey: mp.modelKey
        ))
        return response
    }
    
    @discardableResult
    func removeResponseCache(_ key: String) -> Bool {
        do {
            try MMCache.shared.responseStorage?.removeObject(forKey: key)
            return true
        }
        catch { return false }
    }
    
    @discardableResult
    func removeAllResponseCache() -> Bool {
        do {
            try MMCache.shared.responseStorage?.removeAll()
            return true
        }
        catch { return false }
    }
}

// MARK: JSON
public extension MMCache {
    @discardableResult
    func cacheJSON(_ json: String, key: String, isRAM: Bool = true) -> Bool {
        if isRAM {
            MMCache.shared.jsonRAMStorage.setObject(JSON(json), forKey: key)
            return true
        }
        do {
            try MMCache.shared.jsonStorage?.setObject(JSON(json), forKey: key)
            return true
        }
        catch { return false }
    }
    
    func fetchJSONCache(key: String, isRAM: Bool = true) -> JSON? {
        if isRAM {
            return try? MMCache.shared.jsonRAMStorage.object(forKey: key)
        } else {
            guard let json = try? MMCache.shared.jsonStorage?.object(forKey: key)
                else { return nil }
            return json
        }
    }
    
    @discardableResult
    func removeJSONCache(_ key: String, isRAM: Bool = true) -> Bool {
        if isRAM {
            MMCache.shared.jsonRAMStorage.removeObject(forKey: key)
            return true
        }
        do {
            try MMCache.shared.jsonStorage?.removeObject(forKey: key)
            return true
        }
        catch { return false }
    }
    
    @discardableResult
    func removeAllJSONCache(isRAM: Bool = true) -> Bool {
        if isRAM {
            MMCache.shared.jsonRAMStorage.removeAll()
            return true
        }
        do {
            try MMCache.shared.jsonStorage?.removeAll()
            return true
        }
        catch { return false }
    }
}

// MARK: Modelable
public extension MMCache {
    @discardableResult
    public func cacheModel(_ model: Modelable, key: String, isRAM: Bool = true) -> Bool {
        if isRAM {
            MMCache.shared.jsonRAMStorage.setObject(model.toJSON(), forKey: key)
            return true
        }
        do {
            try MMCache.shared.jsonStorage?.setObject(model.toJSON(), forKey: key)
            return true
        }
        catch { return false }
    }
    
    func fetchModelCache<T: Modelable>(_ type: T.Type, key: String, isRAM: Bool = true) -> T? {
        var model : T?
        if isRAM {
            model = try? MMCache.shared.jsonRAMStorage.object(forKey: key).modelValue(type.self)
        } else {
            guard let json = try? MMCache.shared.jsonStorage?.object(forKey: key) else { return nil }
            model = json?.modelValue(type.self)
        }
        guard let lxf_model = model else { return nil }
        return lxf_model
    }
    
    func fetchModelsCache<T: Modelable>(_ type: T.Type, key: String, isRAM: Bool = true) -> [T] {
        var models : [T]?
        if isRAM {
            models = try? MMCache.shared.jsonRAMStorage.object(forKey: key).modelsValue(type.self)
        } else {
            guard let json = try? MMCache.shared.jsonStorage?.object(forKey: key) else { return [] }
            models = json?.modelsValue(type.self)
        }
        guard let lxf_models = models else { return [] }
        return lxf_models
    }
}

public extension Modelable {
    @discardableResult
    func cache(key: String, isRAM: Bool = true) -> Bool {
        return MMCache.shared.cacheModel(self, key: key, isRAM: isRAM)
    }
    
    static func fromCache(key: String, isRAM: Bool = true) -> Self? {
        return MMCache.shared.fetchModelCache(Self.self, key: key, isRAM: isRAM)
    }
}

public extension Array where Element: Modelable {
    @discardableResult
    func cache(key: String, isRAM: Bool = true) -> Bool {
        return MMCache.shared.cacheJSON(self.toJSONString(), key: key, isRAM: isRAM)
    }
    
    static func fromCache(key: String, isRAM: Bool = true) -> [Element] {
        return MMCache.shared.fetchModelsCache(Element.self, key: key, isRAM: isRAM)
    }
}
