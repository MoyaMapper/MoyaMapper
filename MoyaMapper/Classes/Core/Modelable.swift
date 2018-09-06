//
//  Modelable.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/5/18.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import SwiftyJSON

public struct NullParameter: ModelableParameterType {
    /// 请求成功时状态码对应的值 (默认值 "")
    public static var successValue: String {return ""}
    /// 状态码对应的键 (默认值 "")
    public static var statusCodeKey: String {return ""}
    /// 请求后的提示语对应的键 (默认值 "")
    public static var tipStrKey: String {return ""}
    /// 请求后的主要模型数据的键 (默认值 "")
    public static var modelKey: String {return ""}
}

public protocol ModelableParameterType {
    /// 请求成功时状态码对应的值
    static var successValue: String { get }
    /// 状态码对应的键
    static var statusCodeKey: String { get }
    /// 请求后的提示语对应的键
    static var tipStrKey: String { get }
    /// 请求后的主要模型数据的键
    static var modelKey: String { get }
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
