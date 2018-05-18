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

extension Response {
    /// 将Json解析为多个Model，返回数组，对于不同的json格式需要对该方法进行修改
    public func mapArray<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock?) throws -> [T] {
        guard let json = try mapJSON() as? [String : Any] else {
            throw MoyaError.jsonMapping(self)
        }
        
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let modelKey = parameter.modelKey
        guard let jsonArr = (json[modelKey] as? [[String : Any]]) else {
            throw MoyaError.jsonMapping(self)
        }
        
        return try JSON(jsonArr).arrayValue.compactMap { dict -> T in
            let klass = T.self
            if var obj = klass.init(dict) {
                obj.mapping(dict)
                return obj
            }
            throw MoyaError.jsonMapping(self)
        }
    }
    
    public func mapArrResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock?) throws -> (MoyaMapperResult, [T]) {
        let result = try self.mapJSON()
        
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let resCodeKey = parameter.statusCodeKey
        let resMsgKey = parameter.tipStrKey
        let resSuccessValue = parameter.successValue
        
        let code = JSON(result)[resCodeKey].stringValue
        let msg = JSON(result)[resMsgKey].stringValue
        let models = try mapArray(type, params: params)
        return ((code==resSuccessValue, msg), models)
    }
}

// MARK: - Json -> Observable<Model>
extension ObservableType where E == Response {
    // Json -> JSON
    public func toJSON(modelKey: String? = nil) -> Observable<JSON> {
        return flatMap { response -> Observable<JSON> in
            return Observable.just(try response.toJSON(modelKey: modelKey))
        }
    }

    public func fetchString(keys: [JSONSubscriptType], modelKey: String? = nil) -> Observable<String> {
        return flatMap { response -> Observable<String> in
            return Observable.just(try response.fetchJSONString(modelKey: modelKey, keys: keys))
        }
    }
    
    // 将Json解析为Observable<Model>
    public func mapObject<T: Modelable>(_ type: T.Type, modelKey: String? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self, modelKey: modelKey))
        }
    }
    
    public func mapObjResult(params: ModelableParamsBlock? = nil) -> Observable<MoyaMapperResult> {
        return flatMap({ response -> Observable<MoyaMapperResult> in
            return Observable.just(try response.mapResult(params: params))
        })
    }
    
    public func mapObjResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Observable<(MoyaMapperResult,T)> {
        return flatMap({ response -> Observable<(MoyaMapperResult, T)> in
            return Observable.just(try response.mapObjResult(T.self, params: params))
        })
    }
    
    // 将Json解析为Observable<[Model]>
    public func mapArray<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self, params: params))
        }
    }
    public func mapArrResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Observable<(MoyaMapperResult,[T])> {
        return flatMap({ response -> Observable<(MoyaMapperResult, [T])> in
            return Observable.just(try response.mapArrResult(T.self, params: params))
        })
    }
}

// MARK: - Json -> Single<Model>
extension PrimitiveSequence where TraitType == SingleTrait, E == Response {
    // Json -> JSON
    public func toJSON(modelKey: String? = nil) -> Single<JSON> {
        return flatMap { response -> Single<JSON> in
            return Single.just(try response.toJSON(modelKey: modelKey))
        }
    }
    
    public func fetchString(keys: [JSONSubscriptType], modelKey: String? = nil) -> Single<String> {
        return flatMap { response -> Single<String> in
            return Single.just(try response.fetchJSONString(modelKey: modelKey, keys: keys))
        }
    }
    
    // 将Json解析为Observable<Model>
    public func mapObject<T: Modelable>(_ type: T.Type, modelKey: String? = nil) ->  Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(try response.mapObject(T.self, modelKey: modelKey))
        }
    }
    public func mapResult(params: ModelableParamsBlock? = nil) -> Single<MoyaMapperResult> {
        return flatMap({ response -> Single<MoyaMapperResult> in
            return Single.just(try response.mapResult(params: params))
        })
    }
    public func mapObjResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Single<(MoyaMapperResult,T)> {
        return flatMap({ response -> Single<(MoyaMapperResult, T)> in
            return Single.just(try response.mapObjResult(T.self, params: params))
        })
    }
    
    // 将Json解析为Observable<[Model]>
    public func mapArray<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.mapArray(T.self, params: params))
        }
    }
    public func mapArrResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> Single<(MoyaMapperResult,[T])> {
        return flatMap({ response -> Single<(MoyaMapperResult, [T])> in
            return Single.just(try response.mapArrResult(T.self, params: params))
        })
    }
}
