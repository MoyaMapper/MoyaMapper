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
import Moya

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
            let models = response.mapArray(MyModel.self)
            for model in models {
                print("id -- \(model._id)")
            }
            
            // Result
            let (isSuccess, tipStr) = response.mapResult()
            print("isSuccess -- \(isSuccess)")
            print("tipStr -- \(tipStr)")
            
            // Model
            /*
            let model = response.mapObjResult(MyModel.self)
            */
            
            // 获取指定路径的值
            // response.fetchJSONString(keys: []])
            // response.fetchJSONString(path: "", keys: [])
            
            // 使用自定义模型参数类
            /*
            let (result, models) = response.mapArrayResult(MyModel.self, params: { () -> (ModelableParameterType.Type) in
                return CustomParameter.self
            })
             */
            
        }
        
        /* ============================================================ */
        
        // MARK: Rx
        let rxRequest = lxfNetTool.rx.request(.data(type: .all, size: 10, index: 1))

        // Models
        rxRequest.mapArray(MyModel.self).subscribe(onSuccess: { models in
            for model in models {
                print("id -- \(model._id)")
            }
        }).disposed(by: dispseBag)
        
        // Models + Result
        rxRequest.catchError { (error) -> PrimitiveSequence<SingleTrait, Response> in
            // 捕获请求失败（如：无网状态），自定义response
            let err = error as NSError
            let resBodyDict = ["error":"true", "errMsg":err.localizedDescription]
            let response = Response(resBodyDict, statusCode: 203, parameterType: NetParameter.self)
            return Single.just(response)
        }.mapArrayResult(MyModel.self).subscribe(onSuccess: { (result, models) in
            print("isSuccess --\(result.0)")
            print("tipStr --\(result.1)")
            print("models count -- \(models.count)")
        }).disposed(by: dispseBag)

        // 获取指定路径的值
        rxRequest.fetchString(keys: [0, "_id"]).subscribe(onSuccess: { str in
            // 取第1条数据中的'_id'字段对应的值
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

