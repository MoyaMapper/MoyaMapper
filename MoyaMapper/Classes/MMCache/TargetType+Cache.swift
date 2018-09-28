//
//  TargetType+Cache.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/9/26.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import Moya
import SwiftyJSON

extension TargetType {
    func fetchCacheKey(_ type: MMCache.CacheKeyType) -> String {
        switch type {
        case .base:
            return baseCacheKey
        case .default:
            return cacheKey
        case let .custom(key):
            return cacheKey(with: key)
        }
    }
    
    var cacheParameterTypeKey : String {
        return cacheKey(with: "ParameterTypeKey")
    }
    
    private var baseCacheKey : String {
        return "[\(self.method)]\(self.baseURL.absoluteString)/\(self.path)"
    }
    
    private var cacheKey: String {
        let baseKey = baseCacheKey
        if parameters.isEmpty { return baseKey }
        return baseKey + "?" + parameters
    }
    
    private func cacheKey(with customKey: String) -> String {
        return baseCacheKey + "?" + customKey
    }
    
    private var parameters: String {
        switch self.task {
        case let .requestParameters(parameters, _):
            return JSON(parameters).rawString() ?? ""
        case let .requestCompositeParameters(bodyParameters, _, urlParameters):
            var parameters = bodyParameters
            for (key, value) in urlParameters { parameters[key] = value }
            return JSON(parameters).rawString() ?? ""
        case let .downloadParameters(parameters, _, _):
            return JSON(parameters).rawString() ?? ""
        case let .uploadCompositeMultipart(_, urlParameters):
            return JSON(urlParameters).rawString() ?? ""
        case let .requestCompositeData(_, urlParameters):
            return JSON(urlParameters).rawString() ?? ""
        default: return  ""
        }
    }
}
