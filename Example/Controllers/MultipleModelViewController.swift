//
//  MultipleModelViewController.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyJSON

class MultipleModelViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
//        lxfNetTool.rx.request(.multipleModel)
//            .mapArray(UserModel.self, modelKey: "")
//            .subscribe(onSuccess: { models in
//                for model in models {
//                    print(model.email)
//                    print(model.address.city)
//                    print(model.address.geo.lat)
//                    print(model.company.catchPhrase)
//                }
//            }).disposed(by: disposeBag)
        
        print("--- 本地请求 ---")
        let dict: [String : Any] = [
            "goodJob" : "1",
            "d2" : [
                [
                    "cc":3
                ],
                [
                    "cc":4
                ],
                [
                    "cc":5
                ],
            ],
        ]
        guard let jsonStr = JSON(dict).rawString() else {
            return
        }
        let model = BBB.mapModel(from: jsonStr)
        print("model -- \(model)")
        
        
        print("--- 网络请求 ---")
        TypicodeService.shared.fetchUserInfos()
            .subscribe(onSuccess: { models in
                for model in models {
                    log.debug("\(model.email)")
                    log.debug("\(model.address)")
                }
            }).disposed(by: disposeBag)
    }
}
