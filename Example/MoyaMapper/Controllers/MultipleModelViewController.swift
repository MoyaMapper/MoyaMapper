//
//  MultipleModelViewController.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class MultipleModelViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        lxfNetTool.rx.request(.multipleModel)
            .mapArray(UserModel.self, modelKey: "")
            .subscribe(onSuccess: { models in
                for model in models {
                    print(model.email)
                    print(model.address.city)
                    print(model.address.geo.lat)
                    print(model.company.catchPhrase)
                }
            }).disposed(by: disposeBag)
    }
}
