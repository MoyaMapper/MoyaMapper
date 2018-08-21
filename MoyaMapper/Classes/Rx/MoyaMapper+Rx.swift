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
    /// Response -> Observable<JSON>
    ///
    /// - Parameter modelKey: 模型数据路径
    /// - Returns: Observable<JSON>
    public func toJSON(modelKey: String? = nil) -> Observable<JSON> {
        return flatMap { response -> Observable<JSON> in
            return Observable.just(response.toJSON(modelKey: modelKey))
        }
    }

    /// 获取指定路径的字符串
    ///
    /// - Parameters:
    ///   - keys: 目标数据子路径  (例： [0, "_id"])
    ///   - path: JSON数据路径 (默认为模型数据路径)
    /// - Returns: Observable<String>
    public func fetchString(keys: [JSONSubscriptType] = [], path: String? = nil) -> Observable<String> {
        return flatMap { response -> Observable<String> in
            return Observable.just(response.fetchString(path: path, keys: keys))
        }
    }
    
    /// 获取指定路径的原始json字符串
    ///
    /// - Parameters:
    ///   - keys: 目标数据子路径  (例： [0, "_id"])
    ///   - path: JSON数据路径 (默认为模型数据路径)
    /// - Returns: Observable<String>
    public func fetchJSONString(keys: [JSONSubscriptType] = [], path: String? = nil) -> Observable<String> {
        return flatMap { response -> Observable<String> in
            return Observable.just(response.fetchJSONString(path: path, keys: keys))
        }
    }
    
    /// Response -> Observable<Model>
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - modelKey: 模型数据路径
    /// - Returns: Observable<Model>
    public func mapObject<T: Modelable>(_ type: T.Type, modelKey: String? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(response.mapObject(T.self, modelKey: modelKey))
        }
    }
    
    /// Response -> Observable<MoyaMapperResult>
    ///
    /// - Parameter params: 自定义解析的设置回调
    /// - Returns: Observable<MoyaMapperResult>
    public func mapObjResult(params: ModelableParamsBlock? = nil) -> Observable<MoyaMapperResult> {
        return flatMap({ response -> Observable<MoyaMapperResult> in
            return Observable.just(response.mapResult(params: params))
        })
    }
    
    /// Response -> Observable<(MoyaMapperResult,Model)>
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - params: 自定义解析的设置回调
    /// - Returns: Observable<(MoyaMapperResult,Model)>
    public func mapObjResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Observable<(MoyaMapperResult,T)> {
        return flatMap({ response -> Observable<(MoyaMapperResult, T)> in
            return Observable.just(response.mapObjResult(T.self, params: params))
        })
    }
    
    // 将Json解析为Observable<[Model]>
    /// Response -> Observable<[Model]>
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - modelKey: 模型路径
    /// - Returns: Observable<[Model]>
    public func mapArray<T: Modelable>(_ type: T.Type, modelKey: String? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(response.mapArray(T.self, modelKey: modelKey))
        }
    }
    
    /// Response -> Observable<(MoyaMapperResult, [Model])>
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - params: 自定义解析的设置回调
    /// - Returns: Observable<(MoyaMapperResult, [Model])>
    public func mapArrayResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Observable<(MoyaMapperResult,[T])> {
        return flatMap({ response -> Observable<(MoyaMapperResult, [T])> in
            return Observable.just(response.mapArrayResult(T.self, params: params))
        })
    }
}

// MARK: - Json -> Single<Model>
extension PrimitiveSequence where TraitType == SingleTrait, E == Response {
    /// Response -> Single<JSON>
    ///
    /// - Parameter modelKey: 模型数据路径
    /// - Returns: Single<JSON>
    public func toJSON(modelKey: String? = nil) -> Single<JSON> {
        return flatMap { response -> Single<JSON> in
            return Single.just(response.toJSON(modelKey: modelKey))
        }
    }
    
    /// 获取指定路径的字符串
    ///
    /// - Parameters:
    ///   - keys: 目标数据子路径  (例： [0, "_id"])
    ///   - path: JSON数据路径 (默认为模型数据路径)
    /// - Returns: Single<String>
    public func fetchString(keys: [JSONSubscriptType] = [], path: String? = nil) -> Single<String> {
        return flatMap { response -> Single<String> in
            return Single.just(response.fetchString(path: path, keys: keys))
        }
    }
    
    /// 获取指定路径的原始json字符串
    ///
    /// - Parameters:
    ///   - keys: 目标数据子路径  (例： [0, "_id"])
    ///   - path: JSON数据路径 (默认为模型数据路径)
    /// - Returns: Single<String>
    public func fetchJSONString(keys: [JSONSubscriptType] = [], path: String? = nil) -> Single<String> {
        return flatMap { response -> Single<String> in
            return Single.just(response.fetchJSONString(path: path, keys: keys))
        }
    }
    
    /// Response -> Single<Model>
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - modelKey: 模型数据路径
    /// - Returns: Single<Model>
    public func mapObject<T: Modelable>(_ type: T.Type, modelKey: String? = nil) ->  Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(response.mapObject(T.self, modelKey: modelKey))
        }
    }
    
    /// Response -> Single<MoyaMapperResult>
    ///
    /// - Parameter params: 自定义解析的设置回调
    /// - Returns: Single<MoyaMapperResult>
    public func mapResult(params: ModelableParamsBlock? = nil) -> Single<MoyaMapperResult> {
        return flatMap({ response -> Single<MoyaMapperResult> in
            return Single.just(response.mapResult(params: params))
        })
    }
    
    /// Response -> Single<(MoyaMapperResult,Model)>
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - params: 自定义解析的设置回调
    /// - Returns: Single<(MoyaMapperResult,Model)>
    public func mapObjResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Single<(MoyaMapperResult,T)> {
        return flatMap({ response -> Single<(MoyaMapperResult, T)> in
            return Single.just(response.mapObjResult(T.self, params: params))
        })
    }
    
    // 将Json解析为Single<[Model]>
    /// Response -> Single<[Model]>
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - modelKey: 模型路径
    /// - Returns: Single<[Model]>
    public func mapArray<T: Modelable>(_ type: T.Type, modelKey: String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(response.mapArray(T.self, modelKey: modelKey))
        }
    }
    
    /// Response -> Single<(MoyaMapperResult, [Model])>
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - params: 自定义解析的设置回调
    /// - Returns: Single<(MoyaMapperResult, [Model])>
    public func mapArrayResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Single<(MoyaMapperResult,[T])> {
        return flatMap({ response -> Single<(MoyaMapperResult, [T])> in
            return Single.just(response.mapArrayResult(T.self, params: params))
        })
    }
}
