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
    var parameter: ModelableParameterType.Type
    
    public init<T: ModelableParameterType>(_ type: T.Type) {
        parameter = type
    }
    
    // modify response
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        _ = result.map { (response) -> Response in
            response.setNetParameter(parameter)
            return response
        }
        return result
    }
}
