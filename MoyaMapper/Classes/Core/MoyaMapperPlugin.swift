//
//  MoyaMapperPlugin.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/5/18.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import Moya
import Result

public struct MoyaMapperPlugin: PluginType {
    var parameter: ModelableParameterType
    var transformError: Bool
    
    public init<T: ModelableParameterType>(_ type: T, transformError: Bool = true) {
        parameter = type
        self.transformError = transformError
    }
    
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        /**
         transformError 默认为 true，当请求失败的时候 result.response 为nil，这里会自动创建一个 response 并返回出去。
         
         这里将请求失败进行了统一，无论是服务器还是自身设备的问题，statusCode 都为 MMStatusCode.loadFail，但是 errorDescription 会保持原来的样子

         应用场景：空白页提示加载失败
         */
        if transformError && result.error != nil {
            var errorDict: [String: Any] = [:]
            errorDict[parameter.statusCodeKey] = MMStatusCode.loadFail.rawValue
            errorDict[parameter.tipStrKey] = result.error!.localizedDescription
            let response = Response(errorDict, statusCode: MMStatusCode.loadFail.rawValue, parameter: parameter)
            return Result(value: response)
        }
        
        _ = result.map { (response) -> Response in
            response.setNetParameter(parameter)
            return response
        }
        return result
    }
}
