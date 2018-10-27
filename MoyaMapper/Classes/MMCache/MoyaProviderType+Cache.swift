//
//  MoyaProviderType+Cache.swift
//  MoyaMapper
//
//  Created by 林洵锋 on 2018/10/27.
//

import Moya
import Result

public extension MoyaProviderType {
    /**
     缓存网络请求:
     
     - 如果本地无缓存，直接返回网络请求到的数据
     - 如果本地有缓存，先返回缓存，再返回网络请求到的数据
     - 只会缓存请求成功的数据（缓存的数据 response 的状态码为 MMStatusCode.cache）
     - 适用于APP首页数据缓存
     
     */
    func cacheRequest(_ target: Target, cacheType: MMCache.CacheKeyType = .default, callbackQueue: DispatchQueue? = nil, progress: Moya.ProgressBlock? = nil, completion: @escaping Moya.Completion) -> Cancellable {
        
        if MMCache.shared.isNoRecord(target, cacheType: cacheType) {
            if let cache = MMCache.shared.fetchResponseCache(target: target) {
                completion(Result(value: cache))
            }
        }
        
        return self.request(target, callbackQueue: callbackQueue, progress: progress) { result in
            if let resp = try? result.value?.filterSuccessfulStatusCodes(),
                resp != nil { // 更新缓存
                MMCache.shared.cacheResponse(resp!, target: target)
            }
            completion(result)
        }
    }
}
