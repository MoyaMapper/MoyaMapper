//
//  MultipleModel.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import SwiftyJSON
import MoyaMapper

// network
struct UserModel: Modelable {
    
    var id : String = ""
    var name : String = ""
    var username : String = ""
    var email : String = ""
    var phone : String = ""
    var website : String = ""
    var address : AddressModel = AddressModel()
    var company : CompanyModel = CompanyModel()
    
    mutating func mapping(_ json: JSON) {
        
    }
}

struct AddressModel: Modelable {
    
    var street : String = ""
    var suite : String = ""
    var city : String = ""
    var zipcode : String = ""
    var geo : GeoModel = GeoModel()
    
    mutating func mapping(_ json: JSON) {
        
    }
}

struct GeoModel: Modelable {
    
//    var lat : String = ""
//    var lng : String = ""
    
    var lat : Float = 0
    var lng : Float = 0
    
    mutating func mapping(_ json: JSON) {
        
    }
}

struct CompanyModel: Modelable {
    
    var name : String = ""
    var catchPhrase : String = ""
    var bs : String = ""
    
    mutating func mapping(_ json: JSON) {
        
    }
}


// local
struct AAA: Modelable {
    var c1: String = ""
    mutating func mapping(_ json: JSON) {
        c1 = json["cc"].stringValue
    }
}

struct BBB: Modelable {
    var d1: [AAA] = []
    var goodJob: String = ""
    var d3: Int = 4
    
    mutating func mapping(_ json: JSON) {
        d1 = AAA.mapModels(from: json["d2"].rawString() ?? "")
    }
    
    // 定义解析策略
    func keyDecodingStrategy() -> MMJSONDecoder.KeyDecodingStrategy {
        return .convertFromSnakeCase
    }
    
    // 定义默认值策略
    func customDefaultValueStrategy() -> MMJSONDecoder.NotFoundKeyOrValueDecodingStrategy {
        return .customDefaultValue(MyCustomDefaultValue())
    }
}

// 定义自己的默认值
struct MyCustomDefaultValue: MMJSONDefault {
    var boolValue: Bool { return true }
    var intValue: Int { return 1 }
    var int8Value: Int8 { return 1 }
    var int16Value: Int16 { return 1 }
    var int32Value: Int32 { return 1 }
    var int64Value: Int64 { return 1 }
    var uIntValue: UInt { return 1 }
    var uInt8Value: UInt8 { return 1 }
    var uInt16Value: UInt16 { return 1 }
    var uInt32Value: UInt32 { return 1 }
    var uInt64Value: UInt64 { return 1 }
    var floatValue: Float { return 1 }
    var doubleValue: Double { return 1 }
    var stringValue: String { return "1" }
}

