//
//  CacheViewController.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/9/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import MoyaMapper

class CacheViewController: UIViewController {
    
    fileprivate var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let label = UILabel(frame: CGRect.init(x: 0, y: 150, width: UIScreen.main.bounds.width, height: 100))
        label.textAlignment = .center
        label.text = "点击屏幕"
        self.view.addSubview(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
         * APP第一次启动并进行网络请求，网络数据将缓存起来
         * APP再次启动并进行网络请求时，会先加载缓存，再加载网络数据
         * 其它情况只会加载网络数据
         */
        lxfNetTool.rx.cacheRequest(.data(type: .all, size: 10, index: 1))
            .subscribe(onNext: { response in
                log.debug("statusCode -- \(response.statusCode)")
                log.debug(" ===== cache =====")
            }).disposed(by: disposeBag)
    }
}
