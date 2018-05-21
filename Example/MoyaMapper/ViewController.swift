//
//  ViewController.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 05/18/2018.
//  Copyright (c) 2018 LinXunFeng. All rights reserved.
//

import UIKit
import RxSwift
import Result
import MoyaMapper

class ViewController: UIViewController {
    
    var dispseBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // MARK: Normal
        lxfNetTool.request(.data(type: .all, size: 10, index: 1)) { result in
            guard let response = result.value else { return }
            
            // Models
            guard let models = try? response.mapArray(MyModel.self) else {return}
            for model in models {
                print("id -- \(model._id)")
            }
            
            // 使用自定义模型参数类
            /*
            guard let models = try? response.mapArray(MyModel.self, params: { () -> (ModelableParameterType) in
                return CustomParameter()
            }) else {return}
            */
            
        }
        
        // MARK: Rx
        let rxRequest = lxfNetTool.rx.request(.data(type: .all, size: 10, index: 1))

        // Models
        rxRequest.mapArray(MyModel.self).subscribe(onSuccess: { models in
            for model in models {
                print("id -- \(model._id)")
            }
        }).disposed(by: dispseBag)
        
        // Models + Result
        rxRequest.mapArrayResult(MyModel.self).subscribe(onSuccess: { (result, models) in
            print("isSuccess --\(result.0)")
            print("tipStr --\(result.1)")
            print("models count -- \(models.count)")
        }).disposed(by: dispseBag)

        // 获取指定路径的值
        rxRequest.fetchString(keys: [0, "_id"]).subscribe(onSuccess: { str in
            print("str -- \(str)")
        }).disposed(by: dispseBag)
    }

}

struct CustomParameter: ModelableParameterType {
    static var successValue: String { return "000" }
    static var statusCodeKey: String { return "retCode" }
    static var tipStrKey: String { return "retMsg" }
    static var modelKey: String { return "retBody"}
}

