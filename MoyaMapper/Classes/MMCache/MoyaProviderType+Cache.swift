//
//  MoyaProviderType+Cache.swift
//  MoyaMapper
//
//  Created by 林洵锋 on 2018/10/27.
//

import Moya

public extension MoyaProviderType {
    /**
     缓存网络请求:
     
     - 如果本地无缓存，直接返回网络请求到的数据
     - 如果本地有缓存，先返回缓存，再返回网络请求到的数据
     - 只会缓存请求成功的数据（缓存的数据 response 的状态码为 MMStatusCode.cache）
     - 适用于APP首页数据缓存
     
     */
    func cacheRequest(
        _ target: Target,
        alwaysFetchCache: Bool = false,
        cacheType: MMCache.CacheKeyType = .default,
        callbackQueue: DispatchQueue? = nil,
        progress: Moya.ProgressBlock? = nil,
        completion: @escaping Moya.Completion
    ) -> Cancellable {
        
        let cache = MMCache.shared.fetchResponseCache(target: target)
        
        if alwaysFetchCache && cache != nil {
            completion(.success(cache!))
        } else {
            if MMCache.shared.isNoRecord(target, cacheType: cacheType) {
                MMCache.shared.record(target)
                if cache != nil {
                    completion(.success(cache!))
                }
            }
        }
        
        return self.request(target, callbackQueue: callbackQueue, progress: progress) { result in
            switch result {
            case let .success(response):
                if let resp = try? response.filterSuccessfulStatusCodes() {
                    // 更新缓存
                    MMCache.shared.cacheResponse(resp, target: target)
                }
            default: break
            }
            completion(result)
        }
    }
}
