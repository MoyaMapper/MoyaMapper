//
//  GankApi.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/10/22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Moya
import UIKit

enum GankApiCategory: String {
    case all     = "all"
    case android = "Android"
    case ios     = "iOS"
    case welfare = "福利"
}

enum GankApi {
    case category(_ type: GankApiCategory, size:Int, index:Int)
}

extension GankApi: SugarTargetType {
    
    var baseURL: URL {
        return URL(string: "http://gank.io/api/data/")!
    }
    
    var url: URL {
        return self.defaultURL
    }
    
    var route: Route {
        switch self {
        case let .category(type, size, index): return .get("\(type.rawValue)/\(size)/\(index)")
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
}
