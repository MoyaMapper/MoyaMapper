//
//  MapperParameter.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/9/28.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import SwiftyJSON

public protocol ModelableParameterType: MMConvertable {
    /// 请求成功时状态码对应的值
    var successValue: String { get set }
    /// 状态码对应的键
    var statusCodeKey: String { get set }
    /// 请求后的提示语对应的键
    var tipStrKey: String { get set }
    /// 请求后的主要模型数据的键
    var modelKey: String { get set }
}

public struct TemplateParameter: ModelableParameterType {
    public var successValue: String = ""
    public var statusCodeKey: String = ""
    public var tipStrKey: String = ""
    public var modelKey: String = ""
    
    // Carthage 必须包含init方法，否则使用时会遇到 initializer is inaccessible due to 'internal' protection level
    public init(
        successValue: String = "",
        statusCodeKey: String = "",
        tipStrKey: String = "",
        modelKey: String = ""
    ) {
        self.successValue = successValue
        self.statusCodeKey = statusCodeKey
        self.tipStrKey = tipStrKey
        self.modelKey = modelKey
    }
}

public struct MMResponseParameterKey {
    public static let modelKey = "modelKey"
    public static let statusCodeKey = "statusCodeKey"
    public static let successValue = "successValue"
    public static let tipStrKey = "tipStrKey"
}

public struct MMResponseParameter: Modelable {
    
    public var modelKey: String = ""
    public var statusCodeKey: String = ""
    public var successValue: String = ""
    public var tipStrKey: String = ""
    
    public init() { }
    public mutating func mapping(_ json: JSON) {
        modelKey = json[MMResponseParameterKey.modelKey].stringValue
        statusCodeKey = json[MMResponseParameterKey.statusCodeKey].stringValue
        successValue = json[MMResponseParameterKey.successValue].stringValue
        tipStrKey = json[MMResponseParameterKey.tipStrKey].stringValue
    }
    
    public init(_ mp: ModelableParameterType) {
        self.modelKey = mp.modelKey
        self.statusCodeKey = mp.statusCodeKey
        self.successValue = mp.successValue
        self.tipStrKey = mp.tipStrKey
    }
}
