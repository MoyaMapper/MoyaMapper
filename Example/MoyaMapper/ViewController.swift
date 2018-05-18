//
//  ViewController.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 05/18/2018.
//  Copyright (c) 2018 LinXunFeng. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    var dispseBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let request = lxfNetTool.rx.request(.data(type: .all, size: 10, index: 1))
        
        request.mapArray(MyModel.self).subscribe(onSuccess: { models in
            for model in models {
                print("id -- \(model._id)")
            }
        }).disposed(by: dispseBag)
        
        request.fetchString(keys: [0, "_id"]).subscribe(onSuccess: { str in
            print("str -- \(str)")
        }).disposed(by: dispseBag)
    }

}

