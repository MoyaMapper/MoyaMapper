//
//  Modelable.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/5/18.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import SwiftyJSON

public struct NullParameter: ModelableParameterType {
    public var successValue: String {return ""}
    public var statusCodeKey: String {return ""}
    public var tipStrKey: String {return ""}
    public var modelKey: String {return ""}
}

public protocol ModelableParameterType {
    /// 请求成功时状态码对应的值
    var successValue: String { get }
    /// 状态码对应的键
    var statusCodeKey: String { get }
    /// 请求后的提示语对应的键
    var tipStrKey: String { get }
    /// 请求后的主要模型数据的键
    var modelKey: String { get }
}


// MARK:- Model
public protocol BaseModelable {
    mutating func mapping(_ json: JSON)
}

public protocol Modelable: BaseModelable {
    init?(_ json: JSON)
}

