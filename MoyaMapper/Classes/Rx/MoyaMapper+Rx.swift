//
//  MoyaMapper+Rx.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/5/18.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import RxSwift
import Moya
import SwiftyJSON

// MARK: - Json -> Observable<Model>
extension ObservableType where E == Response {
    // Json -> JSON
    public func toJSON(modelKey: String? = nil) -> Observable<JSON> {
        return flatMap { response -> Observable<JSON> in
            return Observable.just(response.toJSON(modelKey: modelKey))
        }
    }

    public func fetchString(keys: [JSONSubscriptType], path: String? = nil) -> Observable<String> {
        return flatMap { response -> Observable<String> in
            return Observable.just(response.fetchString(path: path, keys: keys))
        }
    }
    
    public func fetchJSONString(keys: [JSONSubscriptType], path: String? = nil) -> Observable<String> {
        return flatMap { response -> Observable<String> in
            return Observable.just(response.fetchJSONString(path: path, keys: keys))
        }
    }
    
    // 将Json解析为Observable<Model>
    public func mapObject<T: Modelable>(_ type: T.Type, modelKey: String? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(response.mapObject(T.self, modelKey: modelKey))
        }
    }
    
    public func mapObjResult(params: ModelableParamsBlock? = nil) -> Observable<MoyaMapperResult> {
        return flatMap({ response -> Observable<MoyaMapperResult> in
            return Observable.just(response.mapResult(params: params))
        })
    }
    
    public func mapObjResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Observable<(MoyaMapperResult,T)> {
        return flatMap({ response -> Observable<(MoyaMapperResult, T)> in
            return Observable.just(response.mapObjResult(T.self, params: params))
        })
    }
    
    // 将Json解析为Observable<[Model]>
    public func mapArray<T: Modelable>(_ type: T.Type, modelKey: String? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(response.mapArray(T.self, modelKey: modelKey))
        }
    }
    public func mapArrayResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Observable<(MoyaMapperResult,[T])> {
        return flatMap({ response -> Observable<(MoyaMapperResult, [T])> in
            return Observable.just(response.mapArrayResult(T.self, params: params))
        })
    }
}

// MARK: - Json -> Single<Model>
extension PrimitiveSequence where TraitType == SingleTrait, E == Response {
    // Json -> JSON
    public func toJSON(modelKey: String? = nil) -> Single<JSON> {
        return flatMap { response -> Single<JSON> in
            return Single.just(response.toJSON(modelKey: modelKey))
        }
    }
    
    public func fetchString(keys: [JSONSubscriptType], path: String? = nil) -> Single<String> {
        return flatMap { response -> Single<String> in
            return Single.just(response.fetchString(path: path, keys: keys))
        }
    }
    public func fetchJSONString(keys: [JSONSubscriptType], path: String? = nil) -> Single<String> {
        return flatMap { response -> Single<String> in
            return Single.just(response.fetchJSONString(path: path, keys: keys))
        }
    }
    
    // 将Json解析为Observable<Model>
    public func mapObject<T: Modelable>(_ type: T.Type, modelKey: String? = nil) ->  Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(response.mapObject(T.self, modelKey: modelKey))
        }
    }
    public func mapResult(params: ModelableParamsBlock? = nil) -> Single<MoyaMapperResult> {
        return flatMap({ response -> Single<MoyaMapperResult> in
            return Single.just(response.mapResult(params: params))
        })
    }
    public func mapObjResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Single<(MoyaMapperResult,T)> {
        return flatMap({ response -> Single<(MoyaMapperResult, T)> in
            return Single.just(response.mapObjResult(T.self, params: params))
        })
    }
    
    // 将Json解析为Observable<[Model]>
    public func mapArray<T: Modelable>(_ type: T.Type, modelKey: String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(response.mapArray(T.self, modelKey: modelKey))
        }
    }
    public func mapArrayResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Single<(MoyaMapperResult,[T])> {
        return flatMap({ response -> Single<(MoyaMapperResult, [T])> in
            return Single.just(response.mapArrayResult(T.self, params: params))
        })
    }
}
