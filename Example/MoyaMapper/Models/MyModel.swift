//
//  MyModel.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2018/5/18.
//  Copyright © 2018年 LinXunFeng. All rights reserved.
//

import SwiftyJSON
import MoyaMapper

struct MyModel: Modelable {
    
    var _id : String = ""
    var created : String = ""
    var desc : String = ""
    var publishedAt : String = ""
    var source : String = ""
    var type : String = ""
    var url : String = ""
    var used : String = ""
    var who : String = ""
    
    init() { }
    mutating func mapping(_ json: JSON) {
        self.created = json["createdAt"].stringValue
    }
}
