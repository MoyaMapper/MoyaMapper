//
//  MMCache+Modelable.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/10/26.
//

#if !COCOAPODS
import MoyaMapper
#endif

public extension MMCache {
    @discardableResult
    func cacheModel(
        _ model: Modelable,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        return MMCache.shared.cacheJSON(model.toJSON(), key: key, cacheContainer: cacheContainer)
    }
    
    func fetchModelCache<T: Modelable>(
        _ type: T.Type,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> T? {
        
        let json = MMCache.shared.fetchJSONCache(key: key, cacheContainer: cacheContainer)
        return json?.codeModel(type.self)
    }
    
    @discardableResult
    func cacheModels<T: Modelable>(
        _ models: [T],
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        return MMCache.shared.cacheJSON(models.toJSON(), key: key, cacheContainer: cacheContainer)
    }
    
    func fetchModelsCache<T: Modelable>(
        _ type: T.Type,
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> [T] {
        let json = MMCache.shared.fetchJSONCache(key: key, cacheContainer: cacheContainer)
        return json?.codeModels(type.self) ?? []
    }
}

// MARK: Modelable
public extension Modelable {
    @discardableResult
    func cache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        return MMCache.shared.cacheModel(self, key: key, cacheContainer: cacheContainer)
    }
    
    static func fromCache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Self? {
        return MMCache.shared.fetchModelCache(Self.self, key: key, cacheContainer: cacheContainer)
    }
}

public extension Array where Element: Modelable {
    @discardableResult
    func cache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> Bool {
        return MMCache.shared.cacheModels(self, key: key, cacheContainer: cacheContainer)
    }
    
    static func fromCache(
        key: String,
        cacheContainer: MMCache.CacheContainer = .RAM
    ) -> [Element] {
        return MMCache.shared.fetchModelsCache(Element.self, key: key, cacheContainer: cacheContainer)
    }
}
