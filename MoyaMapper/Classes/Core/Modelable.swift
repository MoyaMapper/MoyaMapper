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
private var customMappingKey = "customMappingKey"
public protocol Modelable : MMConvertable {
    init()
    mutating func mapping(_ json: JSON)
}

public extension Modelable {
    fileprivate var customMapping : Bool {
        get { return (objc_getAssociatedObject(self, &customMappingKey) as? Bool) ?? true }
        set { objc_setAssociatedObject(self, &customMappingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    mutating func mapping(_ json: JSON) {
        self.customMapping = false
    }
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
        var model = T()
        var _dict: [String: Any] = [:]
        
        for case let (key, value) in Mirror(reflecting: model).children {
            guard let key = key else { continue }
            let _json = self[key]
            var _value : Any?
            switch value {
            case is Bool: _value = _json.boolValue
            case is Int: _value = _json.intValue
            case is Int8: _value = _json.int8Value
            case is Int16: _value = _json.int16Value
            case is Int32: _value = _json.int32Value
            case is Int64: _value = _json.int64Value
            case is UInt: _value = _json.uIntValue
            case is UInt8: _value = _json.uInt8Value
            case is UInt16: _value = _json.uInt16Value
            case is UInt32: _value = _json.uInt32Value
            case is UInt64: _value = _json.uInt64Value
            case is Float: _value = _json.stringValue
            case is Double: _value = _json.doubleValue
            case is String: _value = _json.stringValue
            default: continue
            }
            if _value != nil { _dict[key] = _value }
        }
        
        guard let data =  try? JSONSerialization.data(withJSONObject: _dict, options: .prettyPrinted) else { return model }
        
        let decoder = JSONDecoder()
        if let _model = try? decoder.decode(T.self, from: data) { model = _model }
        
        model.mapping(self)
        return model
    }
    
    /// 模型数组解析
    ///
    /// - Parameter type: 模型类型
    /// - Returns: 模型数组
    public func modelsValue<T: Modelable>(_ type: T.Type) -> [T] {
        return arrayValue.compactMap { $0.modelValue(type) }
    }
}
