//
//  MMCache+Modelable.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/10/26.
//

public extension MMCache {
    @discardableResult
    public func cacheModel(_ model: Modelable, key: String, cacheContainer: MMCache.CacheContainer = .RAM) -> Bool {
        switch cacheContainer {
        case .RAM:
            do {
                try MMCache.shared.jsonStorage?.setObject(model.toJSON(), forKey: key)
                return true
            }
            catch { return false }
        case .hybrid:
            MMCache.shared.jsonRAMStorage.setObject(model.toJSON(), forKey: key)
            return true
        }
    }
    
    func fetchModelCache<T: Modelable>(_ type: T.Type, key: String, cacheContainer: MMCache.CacheContainer = .RAM) -> T? {
        var model : T?
        switch cacheContainer {
        case .RAM:
            model = try? MMCache.shared.jsonRAMStorage.object(forKey: key).modelValue(type.self)
        case .hybrid:
            guard let json = try? MMCache.shared.jsonStorage?.object(forKey: key) else { return nil }
            model = json?.modelValue(type.self)
        }
        guard let lxf_model = model else { return nil }
        return lxf_model
    }
    
    func fetchModelsCache<T: Modelable>(_ type: T.Type, key: String, cacheContainer: MMCache.CacheContainer = .RAM) -> [T] {
        var models : [T]?
        switch cacheContainer {
        case .RAM:
            models = try? MMCache.shared.jsonRAMStorage.object(forKey: key).modelsValue(type.self)
        case .hybrid:
            guard let json = try? MMCache.shared.jsonStorage?.object(forKey: key) else { return [] }
            models = json?.modelsValue(type.self)
        }
        guard let lxf_models = models else { return [] }
        return lxf_models
    }
}

// MARK: Modelable
public extension Modelable {
    @discardableResult
    func cache(key: String, cacheContainer: MMCache.CacheContainer = .RAM) -> Bool {
        return MMCache.shared.cacheModel(self, key: key, cacheContainer: cacheContainer)
    }
    
    static func fromCache(key: String, cacheContainer: MMCache.CacheContainer = .RAM) -> Self? {
        return MMCache.shared.fetchModelCache(Self.self, key: key, cacheContainer: cacheContainer)
    }
}

public extension Array where Element: Modelable {
    @discardableResult
    func cache(key: String, cacheContainer: MMCache.CacheContainer = .RAM) -> Bool {
        return MMCache.shared.cacheJSON(self.toJSON(), key: key, cacheContainer: cacheContainer)
    }
    
    static func fromCache(key: String, cacheContainer: MMCache.CacheContainer = .RAM) -> [Element] {
        return MMCache.shared.fetchModelsCache(Element.self, key: key, cacheContainer: cacheContainer)
    }
}
