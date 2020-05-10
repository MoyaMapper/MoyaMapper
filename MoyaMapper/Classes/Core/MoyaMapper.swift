//
//  MoyaMapper.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/5/18.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import Moya
import SwiftyJSON

public typealias ModelableParamsBlock = ()->(ModelableParameterType)
/// 统一接口请求结果
public typealias MoyaMapperResult = (Bool, String)
/// 路径分割符
fileprivate let pathSplitSymbol: Character = ">"

extension JSON {
    // 统一管理路径
    
    /// 指定路径数据 -> JSON
    ///
    /// - Parameter path: 数据路径
    /// - Returns: JSON
    func json(path: String) -> JSON {
        var json = self
        let pathArr = path.split(separator: pathSplitSymbol)
        for p in pathArr { json = json[String(p)] }
        return json
    }
}

// MARK:- JSON -> Model
extension Response {
    /// Response -> Model
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - modelJson: 模型对应的json数据
    /// - Returns: 模型
    func toModel<T: Modelable>(_ type: T.Type, modelJson: JSON) -> T {
        return modelJson.modelValue(type)
    }
}

// MARK:- Json -> JSON
extension Response {
    /// Response -> JSON
    ///
    /// - Parameter modelKey: 模型数据路径
    /// - Returns: JSON对象
    public func toJSON(modelKey: String? = nil) -> JSON {
        let lxf_modelKey = modelKey == nil ? self.lxf_modelableParameter.modelKey : modelKey!
        let result = JSON(data)
        return result.json(path: lxf_modelKey)
    }
}

// MARK:- Json -> String
extension Response {
    /// 获取指定路径的字符串
    ///
    /// - Parameters:
    ///   - path: JSON数据路径 (默认为模型数据路径)
    ///   - keys: 目标数据子路径  (例： [0, "_id"])
    /// - Returns: 指定路径的字符串
    public func fetchString(
        path: String? = nil,
        keys: [JSONSubscriptType] = []
    ) -> String {
        let resJson = toJSON(modelKey: path)
        return resJson[keys].stringValue
    }
    
    /// 获取指定路径的原始json字符串
    ///
    /// - Parameters:
    ///   - path: JSON数据路径 (默认为根路径)
    ///   - keys: 目标数据子路径  (例： [0, "_id"])
    /// - Returns: 指定路径的原始json字符串
    public func fetchJSONString(
        path: String? = nil,
        keys: [JSONSubscriptType] = []
    ) -> String {
        let rootPath = ""
        let resJson = toJSON(modelKey: path != nil ? path : rootPath)
        return resJson[keys].rawString() ?? ""
    }
}

// MARK:- Json -> ResultStatus
extension Response {
    /// Response -> MoyaMapperResult
    ///
    /// - Parameter params: 自定义解析的设置回调
    /// - Returns: MoyaMapperResult
    public func mapResult(params: ModelableParamsBlock? = nil) -> MoyaMapperResult {
        let result = JSON(data)
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let resCodeKey = parameter.statusCodeKey
        let resMsgKey = parameter.tipStrKey
        let resSuccessValue = parameter.successValue
        
        let code = result.json(path: resCodeKey).stringValue
        let msg = result.json(path: resMsgKey).stringValue
        return (code == resSuccessValue, msg)
    }
    
    /// 获取接口返回的状态码
    ///
    /// - Parameters:
    ///   - path: JSON数据路径 (默认为模型数据路径)
    ///   - keys: 目标数据子路径  (例： [0, "_id"])
    /// - Returns: 接口返回的状态码
    public func fetchStatusCode(
        path: String? = nil,
        keys: [JSONSubscriptType] = []
    ) -> String {
        let resCodeKey = path != nil ? path : lxf_modelableParameter.statusCodeKey
        return self.fetchString(path: resCodeKey, keys: keys)
    }
}

// MARK: - Json -> Model
extension Response {
    /// Response -> Model
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - modelKey: 模型数据路径
    /// - Returns: 模型
    public func mapObject<T: Modelable>(
        _ type: T.Type,
        modelKey: String? = nil
    ) -> T {
        let resJson = toJSON(modelKey: modelKey)
        return toModel(type, modelJson: resJson)
    }

    /// Response -> (MoyaMapperResult, Model)
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - params: 自定义解析的设置回调
    /// - Returns: (MoyaMapperResult, Model)
    public func mapObjResult<T: Modelable>(
        _ type: T.Type,
        params: ModelableParamsBlock? = nil
    ) -> (MoyaMapperResult, T) {
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let modelKey = parameter.modelKey
        let (isSuccess, retMsg) = mapResult(params: params)
        let model = mapObject(type, modelKey: modelKey)
        return ((isSuccess, retMsg), model)
    }
}

// MARK: - Json -> Models
extension Response {
    // 将Json解析为多个Model，返回数组，对于不同的json格式需要对该方法进行修改
    
    /// Response -> [Model]
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - modelKey: 模型路径
    /// - Returns: 模型数组
    public func mapArray<T: Modelable>(
        _ type: T.Type,
        modelKey: String? = nil
    ) -> [T] {
        let lxf_modelKey = modelKey == nil ? self.lxf_modelableParameter.modelKey : modelKey!
        let jsonArr = toJSON(modelKey: lxf_modelKey).arrayValue
        return jsonArr.compactMap { toModel(type, modelJson: $0) }
    }
    
    /// Response -> (MoyaMapperResult, [Model])
    ///
    /// - Parameters:
    ///   - type: 模型类型
    ///   - params: 自定义解析的设置回调
    /// - Returns: (MoyaMapperResult, [Model])
    public func mapArrayResult<T: Modelable>(
        _ type: T.Type,
        params: ModelableParamsBlock? = nil
    ) -> (MoyaMapperResult, [T]) {
        let parameter = params != nil ? params!() : lxf_modelableParameter
        let modelKey = parameter.modelKey
        let result = mapResult(params: params)
        
        let models = mapArray(type, modelKey: modelKey)
        return (result, models)
    }
}

// MARK:- runtime
extension Response {
    // 主要用于 catchError
    
    /// 创建Response
    ///
    /// - Parameters:
    ///   - dataDict: 数据字典
    ///   - statusCode: 状态码
    ///   - parameterType: ModelableParameterType
    public convenience init(
        _ dataDict: [String: Any],
        statusCode: Int,
        parameter: ModelableParameterType
    ) {
        defer { self.setNetParameter(parameter) }
        let jsonData = (try? JSON(dataDict).rawData()) ?? Data()
        self.init(statusCode: statusCode, data: jsonData)
    }
    
    /// 设置数据解析参数
    ///
    /// - Parameter type: ModelableParameterType
    public func setNetParameter(_ type: ModelableParameterType) {
        self.lxf_modelableParameter = type
    }
    
    private struct AssociatedKeys {
        static var lxf_modelableParameterKey = "lxf_modelableParameterKey"
    }
    public internal(set) var lxf_modelableParameter: ModelableParameterType {
        get {
            // https://stackoverflow.com/questions/42033735/failing-cast-in-swift-from-any-to-protocol/42034523#42034523
            let value = objc_getAssociatedObject(self, &AssociatedKeys.lxf_modelableParameterKey) as AnyObject
            guard let type = value as? ModelableParameterType else { return TemplateParameter() }
            return type
        } set {
            objc_setAssociatedObject(self, &AssociatedKeys.lxf_modelableParameterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
