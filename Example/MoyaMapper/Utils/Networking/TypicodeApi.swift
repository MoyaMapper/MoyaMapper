//
//  TypicodeApi.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/10/22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Moya
import UIKit

enum TypicodeApi {
    case users
}

extension TypicodeApi: SugarTargetType {
    
    var baseURL: URL {
        return URL(string: "http://jsonplaceholder.typicode.com/")!
    }
    
    var url: URL {
        return self.defaultURL
    }
    
    var route: Route {
        switch self {
        case .users: return .get("users")
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
