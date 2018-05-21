//
//  MoyaMapper.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/5/18.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import Moya
import SwiftyJSON

public typealias ModelableParamsBlock = ()->(ModelableParameterType.Type)
public typealias MoyaMapperResult = (Bool, String)

// MARK:- Json -> JSON
extension Response {
    public func toJSON(modelKey: String? = nil) throws -> JSON {
        let result =  try mapJSON()
        let lxf_modelKey = modelKey == nil ? self.lxf_modelableParameter.modelKey : modelKey!
        return JSON(result)[lxf_modelKey]
    }
    
    public func fetchJSONString(modelKey: String? = nil, keys: [JSONSubscriptType]) throws -> String {
        var resJson = try toJSON(modelKey: modelKey)
        for key in keys {
            resJson = resJson[key]
        }
        return resJson.stringValue
    }
}

// MARK: - Json -> Model
extension Response {
    /// 将Json解析为单个Model
    public func mapObject<T: Modelable>(_ type: T.Type, modelKey: String? = nil) throws -> T {
        let resJson = try toJSON(modelKey: modelKey)

        let klass = T.self
        if var obj = klass.init(resJson) {
            obj.mapping(resJson)
            return obj
        }
        throw MoyaError.jsonMapping(self)
    }

    public func mapResult(params: ModelableParamsBlock? = nil) throws -> MoyaMapperResult {
        let result = try self.mapJSON()
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let resCodeKey = parameter.statusCodeKey
        let resMsgKey = parameter.tipStrKey
        let resSuccessValue = parameter.successValue
        
        let code = JSON(result)[resCodeKey].stringValue
        let msg = JSON(result)[resMsgKey].stringValue
        return (code==resSuccessValue, msg)
    }

    public func mapObjResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) throws -> (MoyaMapperResult, T) {
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let modelKey = parameter.modelKey
        let (isSuccess, retMsg) = try mapResult(params: params)
        let model = try mapObject(type, modelKey: modelKey)
        return ((isSuccess, retMsg), model)
    }
}

// MARK: - Json -> Models
extension Response {
    /// 将Json解析为多个Model，返回数组，对于不同的json格式需要对该方法进行修改
    public func mapArray<T: Modelable>(_ type: T.Type, modelKey: String? = nil) throws -> [T] {
        guard let json = try mapJSON() as? [String : Any] else {
            throw MoyaError.jsonMapping(self)
        }
        
        let lxf_modelKey = modelKey == nil ? self.lxf_modelableParameter.modelKey : modelKey!
        let jsonArr = JSON(json)[lxf_modelKey].arrayValue
        
        return try jsonArr.compactMap { dict -> T in
            let klass = T.self
            if var obj = klass.init(dict) {
                obj.mapping(dict)
                return obj
            }
            throw MoyaError.jsonMapping(self)
        }
    }
    
    public func mapArrayResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) throws -> (MoyaMapperResult, [T]) {
        let result = try self.mapJSON()
        
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let resCodeKey = parameter.statusCodeKey
        let resMsgKey = parameter.tipStrKey
        let resSuccessValue = parameter.successValue
        let modelKey = parameter.modelKey
        
        let code = JSON(result)[resCodeKey].stringValue
        let msg = JSON(result)[resMsgKey].stringValue
        let models = try mapArray(type, modelKey: modelKey)
        return ((code==resSuccessValue, msg), models)
    }
}

// MARK:- runtime
extension Response {
    private struct AssociatedKeys {
        static var lxf_modelableParameterKey = "lxf_modelableParameterKey"
    }
    var lxf_modelableParameter: ModelableParameterType.Type {
        get {
            // https://stackoverflow.com/questions/42033735/failing-cast-in-swift-from-any-to-protocol/42034523#42034523
            let value = objc_getAssociatedObject(self, &AssociatedKeys.lxf_modelableParameterKey) as AnyObject
            guard let type = value as? ModelableParameterType.Type else { return NullParameter.self }
            return type
        } set {
            objc_setAssociatedObject(self, &AssociatedKeys.lxf_modelableParameterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
