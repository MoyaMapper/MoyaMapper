//
//  Modelable.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/5/18.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import SwiftyJSON

public enum MMStatusCode: Int {
    case cache = 230
    case loadFail = 700
}

// MARK:- Model
public protocol Modelable : MMConvertable {
    init(_ json: JSON)
}

public extension Modelable {
    static func mapModel(from jsonString: String) -> Self {
        return JSON(parseJSON: jsonString).modelValue(Self.self)
    }
    static func mapModels(from jsonString: String) -> [Self] {
        return JSON(parseJSON: jsonString).modelsValue(Self.self)
    }
}

public extension Array where Element: Modelable {
    func toJSONString() -> String {
        let dictArr = self.map { $0.toDictionary() }
        guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else { return "" }
        guard let json = try? JSON(data: data) else { return "" }
        return json.rawString() ?? ""
    }
}

extension JSON {
    /// 模型解析
    ///
    /// - Parameter type: 模型类型
    /// - Returns: 模型
    public func modelValue<T: Modelable>(_ type: T.Type) -> T {
        return T.init(self)
    }
    
    /// 模型数组解析
    ///
    /// - Parameter type: 模型类型
    /// - Returns: 模型数组
    public func modelsValue<T: Modelable>(_ type: T.Type) -> [T] {
        return arrayValue.compactMap { $0.modelValue(type) }
    }
}
