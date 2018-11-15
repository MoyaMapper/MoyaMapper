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
    
    public func process(
        _ result: Result<Response, MoyaError>,
        target: TargetType
    ) -> Result<Response, MoyaError> {
        /**
         transformError 默认为 true，当请求失败的时候，这里会自动创建一个 response 并返回出去。
         
         这里将请求失败进行了统一，无论是服务器还是自身设备的问题，statusCode 都为 MMStatusCode.loadFail，
         如果有 result.error 的存在，则 errorDescription 会保持 result.error 原来的样子，
         否则，则 errorDescription 为 response.statusCode

         应用场景：空白页提示加载失败
         */
        if transformError && result.error != nil {
            // 捕捉设备问题，如 网络不可达
            let response = failResponse(
                statusCode: MMStatusCode.loadFail.rawValue,
                errorMsg: result.error!.localizedDescription
            )
            return Result(value: response)
        }
        
        guard let response = result.value else { return result }
        
        // 捕捉其它问题，如 400
        guard let resp = try? response.filterSuccessfulStatusCodes() else {
            return Result(value: failResponse(
                statusCode: response.statusCode,
                errorMsg: result.error?.localizedDescription ?? "\(response.statusCode)"
            ))
        }
        resp.setNetParameter(parameter)
        return Result(value: resp)
    }
    
    fileprivate func failResponse(
        statusCode: Int,
        errorMsg: String
    ) -> Response {
        var errorDict: [String: Any] = [:]
        errorDict[parameter.statusCodeKey] = MMStatusCode.loadFail.rawValue
        errorDict[parameter.tipStrKey] = errorMsg
        return Response(errorDict, statusCode: statusCode, parameter: parameter)
    }
}
