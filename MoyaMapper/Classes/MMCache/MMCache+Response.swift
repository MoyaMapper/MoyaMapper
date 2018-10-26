//
//  MMCache+Response.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/10/26.
//

import Moya

extension MMCache {
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
    func cacheResponse(_ response: Moya.Response, target: TargetType, cacheKey: CacheKeyType = .default) -> Bool {
        do {
            try MMCache.shared.responseStorage?.setObject(response, forKey: target.fetchCacheKey(cacheKey))
            let mp = MMResponseParameter(response.lxf_modelableParameter)
            mp.cache(key: target.cacheParameterTypeKey)
            try MMCache.shared.jsonStorage?.setObject(mp.toJSON(), forKey: target.cacheParameterTypeKey)
            return true
        }
        catch { return false }
    }
    func fetchResponseCache(target: TargetType, cacheKey: CacheKeyType = .default) -> Moya.Response? {
        guard let response = try? MMCache.shared.responseStorage?.object(forKey: target.fetchCacheKey(cacheKey))
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
