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
    
    var id : String
    var name : String
    var username : String
    var email : String
    var phone : String
    var website : String
    var address : AddressModel
    var company : CompanyModel
    
    init(_ json: JSON) {
        
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.username = json["username"].stringValue
        self.email = json["email"].stringValue
        self.phone = json["phone"].stringValue
        self.website = json["website"].stringValue
        self.address = json["address"].modelValue(AddressModel.self)
        self.company = json["company"].modelValue(CompanyModel.self)
    }
}

struct AddressModel: Modelable {
    
    var street : String
    var suite : String
    var city : String
    var zipcode : String
    var geo : GeoModel
    
    init(_ json: JSON) {
        
        self.street = json["street"].stringValue
        self.suite = json["suite"].stringValue
        self.city = json["city"].stringValue
        self.zipcode = json["zipcode"].stringValue
        self.geo = json["geo"].modelValue(GeoModel.self)
    }
}

struct GeoModel: Modelable {
    
    var lat : String
    var lng : String
    
    init(_ json: JSON) {
        self.lat = json["lat"].stringValue
        self.lng = json["lng"].stringValue
    }
}

struct CompanyModel: Modelable {
    
    var name : String
    var catchPhrase : String
    var bs : String
    
    init(_ json: JSON) {
        
        self.name = json["name"].stringValue
        self.catchPhrase = json["catchPhrase"].stringValue
        self.bs = json["bs"].stringValue
    }
}
