//
//  TransformerFactory+Ex.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/9/27.
//

import Cache
import SwiftyJSON
import Moya
#if !COCOAPODS
import MoyaMapper
#endif

extension TransformerFactory {
    static func forResponse<T: Moya.Response>(_ type : T.Type) -> Transformer<T> {
        let toData: (T) throws -> Data = { $0.data }
        let fromData: (Data) throws -> T = {
            T(statusCode:  MMStatusCode.cache.rawValue, data: $0)
        }
        return Transformer<T>(toData: toData, fromData: fromData)
    }
    
    static func forJSON() -> Transformer<JSON> {
        let toData: (Any) throws -> Data = { try JSON($0).rawData() }
        let fromData: (Data) throws -> JSON = { return try JSON(data: $0) }
        return Transformer<JSON>(toData: toData, fromData: fromData)
    }
}
