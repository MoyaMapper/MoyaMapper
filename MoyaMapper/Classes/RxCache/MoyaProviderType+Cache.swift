//
//  MoyaProviderType+Cache.swift
//  Alamofire
//
//  Created by LinXunFeng on 2018/9/26.
//

import Moya
import RxSwift

public extension Reactive where Base: MoyaProviderType {
    /**
     缓存网络请求:
     
     - 如果本地无缓存，直接返回网络请求到的数据
     - 如果本地有缓存，先返回缓存，再返回网络请求到的数据
     - 只会缓存请求成功的数据（缓存的数据 response 的状态码为 MMStatusCode.cache）
     - 适用于APP首页数据缓存
     
     */
    func cacheRequest(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Observable<Response> {
        var originRequest = request(token, callbackQueue: callbackQueue).asObservable()
        var cacheResponse: Response? = nil
        
        if MMCache.shared.isNoRecord(token) {
            if let cache = MMCache.shared.fetchResponseCache(target: token) {
                cacheResponse = cache
            }
            originRequest = originRequest.map { response -> Response in
                let resp = try response.filterSuccessfulStatusCodes()
                MMCache.shared.cacheResponse(resp, target: token)
                return response
            }
        }
        
        guard let lxf_cacheResponse = cacheResponse else { return originRequest }
        return Observable.just(lxf_cacheResponse).concat(originRequest)
    }
}
