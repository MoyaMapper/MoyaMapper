//
//  GankService.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/10/22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Moya
import MoyaMapper
import RxSwift

final class GankService {
    fileprivate let networking: GankNetworking
    
    static let shared = GankService(GankNetworking(plugins: [gankParameterPlugin]))
    
    fileprivate init(_ networking: GankNetworking) {
        self.networking = networking
    }
}

extension GankService {
    func request(_ type: GankApiCategory, size:Int, index:Int) -> Single<[MyModel]> {
        return self.networking.request(.category(type, size: size, index: index))
            .mapArray(MyModel.self)
    }
}

let gankParameterPlugin = MoyaMapperPlugin(GankNetParameter())
struct GankNetParameter : ModelableParameterType {
    // 可以任意指定位置的值，如： "error>used"
    var successValue = "false"
    var statusCodeKey = "error"
    var tipStrKey = "errMsg"
    var modelKey = "results"
}
