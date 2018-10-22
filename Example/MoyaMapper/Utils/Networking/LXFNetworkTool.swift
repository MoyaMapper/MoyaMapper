//
//  LXFNetworkTool.swift
//  RxSwiftDemo
//
//  Created by 林洵锋 on 2017/9/7.
//  Copyright © 2017年 LXF. All rights reserved.
//

import Foundation
import Moya
import MoyaMapper

enum LXFNetworkTool {
    
    enum LXFNetworkCategory: String {
        case all     = "all"
        case android = "Android"
        case ios     = "iOS"
        case welfare = "福利"
    }
    enum LXFJsonserverCategory: String {
        case obj     = "obj"
        case array   = "array"
        case fail    = "fail"
    }
    case data(type: LXFNetworkCategory, size:Int, index:Int)
    case multipleModel
    case jsonserver(type: LXFJsonserverCategory)
}

extension LXFNetworkTool: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    /// The target's base `URL`.
    var baseURL: URL {
        switch self {
        case .multipleModel:
            return URL(string: "http://jsonplaceholder.typicode.com/")!
        case .jsonserver:
            return URL(string: "http://127.0.0.1:3000/")!
        default:
            return URL(string: "http://gank.io/api/data/")!
        }
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .multipleModel:
            return "users"
        case .data(let type, let size, let index):
            return "\(type.rawValue)/\(size)/\(index)"
        case .jsonserver(let type):
            return "\(type.rawValue)"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        return nil
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "LinXunFeng".data(using: .utf8)!
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        return .requestPlain
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return false
    }
}

struct NetParameter : ModelableParameterType {
    // 可以任意指定位置的值，如： "error>used"
    var successValue = "false"
    var statusCodeKey = "error"
    var tipStrKey = "errMsg"
    var modelKey = "results"
}

let lxfNetTool = MoyaProvider<LXFNetworkTool>(plugins: [MoyaMapperPlugin(NetParameter())])



// MARK:- 自定义网络结果参数
struct CustomNetParameter: ModelableParameterType {
    var successValue = "000"
    var statusCodeKey = "retCode"
    var tipStrKey = "retMsg"
    var modelKey = "retBody"
}
