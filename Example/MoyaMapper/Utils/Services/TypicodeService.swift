//
//  TypicodeService.swift
//  MoyaMapper_Example
//
//  Created by 林洵锋 on 2018/10/23.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Moya
import MoyaMapper
import RxSwift

class TypicodeService {
    fileprivate let networking: TypicodeNetworking
    
    static let shared = TypicodeService(TypicodeNetworking(plugins: [typicodeParameterPlugin]))
    
    fileprivate init(_ networking: TypicodeNetworking) {
        self.networking = networking
    }
}

extension TypicodeService {
    func fetchUserInfos() -> Single<[UserModel]> {
        return self.networking.request(.users)
            .mapArray(UserModel.self)
    }
}

let typicodeParameterPlugin = MoyaMapperPlugin(TypicodeNetParameter())
struct TypicodeNetParameter : ModelableParameterType {
    // 可以任意指定位置的值，如： "error>used"
    var successValue = ""
    var statusCodeKey = ""
    var tipStrKey = ""
    var modelKey = ""
}
