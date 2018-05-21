//
//  Modelable.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/5/18.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import SwiftyJSON

public struct NullParameter: ModelableParameterType {
    public static var successValue: String {return ""}
    public static var statusCodeKey: String {return ""}
    public static var tipStrKey: String {return ""}
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
public protocol BaseModelable {
    mutating func mapping(_ json: JSON)
}

public protocol Modelable: BaseModelable {
    init(_ json: JSON)
}

