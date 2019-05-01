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
    init()
    mutating func mapping(_ json: JSON)
    
    /// 自定义解析策略
    func keyDecodingStrategy() -> MMJSONDecoder.KeyDecodingStrategy
    
    /// 自定义默认值策略
    func customDefaultValueStrategy() -> MMJSONDecoder.NotFoundKeyOrValueDecodingStrategy
}

public extension Modelable {
    func keyDecodingStrategy() -> MMJSONDecoder.KeyDecodingStrategy {
        return .useDefaultKeys
    }
    func customDefaultValueStrategy() -> MMJSONDecoder.NotFoundKeyOrValueDecodingStrategy {
        return .MMDefaultValue
    }
}

public extension Modelable {
    /// Modelable -> mapping -> Model
    static func mapModel(from object: Any) -> Self {
        return Self.toJSON(with: object).modelValue(Self.self)
    }
    /// Modelable -> mapping -> Models
    static func mapModels(from object: Any) -> [Self] {
        return Self.toJSON(with: object).modelsValue(Self.self)
    }
    
    /*
     * 以下两个方法使用情景主要用于 Model -> Any -> Model
     *
     * let model: Modelable = ...
     * let jsonStr = model.toJSONString()
     
     * let model1 = MyModel.mapModel(from: jsonStr)
     * let model2 = MyModel.codeModel(from: jsonStr)
     *
     * log.debug("model.created -- \(model.created)") // "2018-02-23T07:47:12.993Z"
     *
     * log.debug("model1.created -- \(model1.created)") // ""
     * log.debug("model2.created -- \(model2.created)") // "2018-02-23T07:47:12.993Z"
     */
    
    /// Codeable -> Model
    static func codeModel(from object: Any) -> Self {
        return Self.toJSON(with: object).codeModel(Self.self)
    }
    /// Codeable -> Models
    static func codeModels(from object: Any) -> [Self] {
        return Self.toJSON(with: object).codeModels(Self.self)
    }
    
    /// Any -> JSON
    internal static func toJSON(with object: Any) -> JSON {
        var json: JSON
        switch object  {
        case let object as String:
            json = JSON(parseJSON: object)
        default:
            json = JSON(object)
        }
        return json
    }
}

public extension Array where Element: Modelable {
    func toJSON() -> JSON {
        let dictArr = self.map { $0.toDictionary() }
        guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else { return JSON() }
        guard let json = try? JSON(data: data) else { return JSON() }
        return json
    }
    func toJSONString() -> String {
        return toJSON().rawString() ?? ""
    }
}

extension JSON {
    /// 模型解析
    ///
    /// - Parameter type: 模型类型
    /// - Returns: 模型
    public func modelValue<T: Modelable>(_ type: T.Type) -> T {
        var model = T()
        
        guard let data = try? JSONSerialization.data(withJSONObject: self.dictionaryObject ?? [:], options: .prettyPrinted) else {
            return model
        }
        
        let decoder = MMJSONDecoder()
        decoder.keyDecodingStrategy = model.keyDecodingStrategy()
        decoder.notFoundKeyOrValueDecodingStrategy = model.customDefaultValueStrategy()
        if let _model = try? decoder.decode(T.self, from: data) {
            model = _model
        }
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
    
    /// System Codable Model
    ///
    /// - Parameter type: T: Modelable
    /// - Returns: T
    public func codeModel<T: Modelable>(_ type: T.Type) -> T {
        var model = T()
        
        guard let data = try? JSONSerialization.data(withJSONObject: self.dictionaryObject ?? [:], options: .prettyPrinted) else {
            return model
        }
        
        let decoder = JSONDecoder()
        if let _model = try? decoder.decode(T.self, from: data) {
            model = _model
        }
        return model
    }
    
    /// System Codable Models
    ///
    /// - Parameter type: T: Modelable
    /// - Returns: [T]
    public func codeModels<T: Modelable>(_ type: T.Type) -> [T] {
        return arrayValue.compactMap { $0.codeModel(type) }
    }
}
