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
fileprivate let pathSplitSymbol: Character = ">"

extension JSON {
    /// 统一管理路径
    func json(path: String) -> JSON {
        var json = self
        let pathArr = path.split(separator: pathSplitSymbol)
        for p in pathArr { json = json[String(p)] }
        return json
    }
}

// MARK:- JSON -> Model
extension Response {
    func toModel<T: Modelable>(_ type: T.Type, modelJson: JSON) -> T {
        var obj = T.init(modelJson)
        obj.mapping(modelJson)
        return obj
    }
}

// MARK:- Json -> JSON
extension Response {
    public func toJSON(modelKey: String? = nil) -> JSON {
        let lxf_modelKey = modelKey == nil ? self.lxf_modelableParameter.modelKey : modelKey!
        let result = JSON(data)
        return result.json(path: lxf_modelKey)
    }
    
    public func fetchJSONString(path: String? = nil, keys: [JSONSubscriptType]) -> String {
        var resJson = toJSON(modelKey: path)
        for key in keys {
            resJson = resJson[key]
        }
        return resJson.stringValue
    }
}

// MARK: - Json -> Model
extension Response {
    /// 将Json解析为单个Model
    public func mapObject<T: Modelable>(_ type: T.Type, modelKey: String? = nil) -> T {
        let resJson = toJSON(modelKey: modelKey)
        return toModel(type, modelJson: resJson)
    }

    public func mapResult(params: ModelableParamsBlock? = nil) -> MoyaMapperResult {
        let result = JSON(data)
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let resCodeKey = parameter.statusCodeKey
        let resMsgKey = parameter.tipStrKey
        let resSuccessValue = parameter.successValue
        
        let code = result.json(path: resCodeKey).stringValue
        let msg = result.json(path: resMsgKey).stringValue
        return (code==resSuccessValue, msg)
    }

    public func mapObjResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> (MoyaMapperResult, T) {
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let modelKey = parameter.modelKey
        let (isSuccess, retMsg) = mapResult(params: params)
        let model = mapObject(type, modelKey: modelKey)
        return ((isSuccess, retMsg), model)
    }
}

// MARK: - Json -> Models
extension Response {
    /// 将Json解析为多个Model，返回数组，对于不同的json格式需要对该方法进行修改
    public func mapArray<T: Modelable>(_ type: T.Type, modelKey: String? = nil) -> [T] {
        let lxf_modelKey = modelKey == nil ? self.lxf_modelableParameter.modelKey : modelKey!
        let jsonArr = toJSON(modelKey: lxf_modelKey).arrayValue
        return jsonArr.compactMap { toModel(type, modelJson: $0) }
    }
    
    public func mapArrayResult<T: Modelable>(_ type: T.Type, params: ModelableParamsBlock? = nil) -> (MoyaMapperResult, [T]) {
        let result = JSON(data)
        
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let resCodeKey = parameter.statusCodeKey
        let resMsgKey = parameter.tipStrKey
        let resSuccessValue = parameter.successValue
        let modelKey = parameter.modelKey
        
        let code = result.json(path: resCodeKey).stringValue
        let msg = result.json(path: resMsgKey).stringValue
        let models = mapArray(type, modelKey: modelKey)
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
