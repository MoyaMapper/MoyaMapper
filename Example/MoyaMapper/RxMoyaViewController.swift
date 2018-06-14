//
//  RxMoyaViewController.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import MoyaMapper
import Moya

class RxMoyaViewController: BaseViewController {
    
    fileprivate let rxRequest = lxfNetTool.rx.request(.data(type: .all, size: 10, index: 1))
    
    // UI
    fileprivate var tableView : UITableView!
    fileprivate let sections: [RxMoyaSection] = [
        RxMoyaSection.requests([
            .models,
            .result,
            .modelsResult,
            .fetchString,
            .customNetParamer
        ])
    ]
    fileprivate let dataSource : RxTableViewSectionedReloadDataSource<RxMoyaSection> = {
        return RxTableViewSectionedReloadDataSource.init(configureCell: { (dataSource, tableView, indexPath, sectionItem) -> UITableViewCell in
            let cellID = "NormalMoyaViewCellID"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
            if cell == nil { cell = UITableViewCell(style: .default, reuseIdentifier: cellID) }
            
            switch sectionItem {
            case .models:
                cell?.textLabel?.text = "models"
            case .result:
                cell?.textLabel?.text = "result"
            case .modelsResult:
                cell?.textLabel?.text = "modelsResult"
            case .fetchString:
                cell?.textLabel?.text = "fetchString"
            case .customNetParamer:
                cell?.textLabel?.text = "customNetParamer"
            }
            
            return cell!
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
}

// MARK:- Actions
extension RxMoyaViewController {
    // MARK: 获取 模型数组
    fileprivate func models() {
        rxRequest.mapArray(MyModel.self).subscribe(onSuccess: { models in
            for model in models {
                print("id -- \(model._id)")
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: 获取 请求结果
    fileprivate func result() {
        rxRequest.mapResult().subscribe(onSuccess: { (isSuccess, tipStr) in
            print("isSuccess -- \(isSuccess)")
            print("tipStr -- \(tipStr)")
        }).disposed(by: disposeBag)
    }
    
    // MARK: 获取 模型数组 + 请求结果
    fileprivate func modelsResult() {
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
            }).disposed(by: disposeBag)
    }
    
    // MARK: 获取 指定路径的值
    fileprivate func fetchString() {
        // 获取指定路径的值
        rxRequest.fetchString(keys: [0, "_id"]).subscribe(onSuccess: { str in
            // 取第1条数据中的'_id'字段对应的值
            print("str -- \(str)")
        }).disposed(by: disposeBag)
    }
    
    // MARK: 使用自定义模型参数类
    fileprivate func customNetParamer() {
        rxRequest.mapResult { () -> (ModelableParameterType.Type) in
            return CustomNetParameter.self
        }.subscribe(onSuccess: { (isSuccess, tipStr) in
            print("isSuccess -- \(isSuccess)")
            print("tipStr -- \(tipStr)")
        }).disposed(by: disposeBag)
    }
    
    // MARK: 其它
    fileprivate func other() {
        /*
        rxRequest.mapObjResult(MyModel.self)
        rxRequest.mapArrayResult(MyModel.self)
        rxRequest.mapObject(MyModel.self)
        rxRequest.mapObject(MyModel.self, modelKey: "results")
        rxRequest.mapArray(MyModel.self, modelKey: "results")
         */
    }
}

// MARK:- UI
extension RxMoyaViewController: UITableViewDelegate {
    fileprivate func initUI() {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.view.addSubview(tableView)
        Observable.just(sections).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.itemSelected(dataSource: dataSource).subscribe(onNext: { [weak self] (sectionItem) in
            switch sectionItem {
            case .models:
                self?.models()
            case .result:
                self?.result()
            case .modelsResult:
                self?.modelsResult()
            case .fetchString:
                self?.fetchString()
            case .customNetParamer:
                self?.customNetParamer()
            }
        }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
