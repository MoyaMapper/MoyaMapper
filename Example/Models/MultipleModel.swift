//
//  MultipleModel.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import SwiftyJSON
import MoyaMapper

struct UserModel: Modelable {
    
    var id : String = ""
    var name : String = ""
    var username : String = ""
    var email : String = ""
    var phone : String = ""
    var website : String = ""
    var address : AddressModel = AddressModel()
    var company : CompanyModel = CompanyModel()
    
    init() { }
}

struct AddressModel: Modelable {
    
    var street : String = ""
    var suite : String = ""
    var city : String = ""
    var zipcode : String = ""
    var geo : GeoModel = GeoModel()
    
    init() { }
}

struct GeoModel: Modelable {
    
    var lat : String = ""
    var lng : String = ""
    
    init() { }
}

struct CompanyModel: Modelable {
    
    var name : String = ""
    var catchPhrase : String = ""
    var bs : String = ""
    
    init() { }
}
