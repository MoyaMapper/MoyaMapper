//
//  NormalMoyaViewController.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Moya
import MoyaMapper

class NormalMoyaViewController: BaseViewController {
    
    typealias moyaResult = Result<Moya.Response, MoyaError>
    
    fileprivate var tableView : UITableView!
    fileprivate let dataArray = [
        "models",
        "result",
        "modelsResult",
        "fetchString",
        "customNetParamer"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
}

// MARK:- Actions
extension NormalMoyaViewController {
    // MARK: 获取 模型数组
    fileprivate func models(_ result: moyaResult) {
        switch result {
        case let .success(response):
            print("json -- \(response.fetchJSONString())")
            let models = response.mapArray(MyModel.self)
            for model in models {
                print("createdAt -- \(model.created)")
            }
        default: return
        }
        
        /*
        let jsonArrStr = models.toJSONString()
        let models1 = MyModel.mapModels(from: jsonArrStr)
        let models2 = MyModel.codeModels(from: jsonArrStr)
        
        let model = models[0]
        let jsonStr = model.toJSONString()
        let model1 = MyModel.mapModel(from: jsonStr)
        let model2 = MyModel.codeModel(from: jsonStr)
        log.debug("model1 -- \(model1)")
        log.debug("model2 -- \(model2)")
        */
    }
    
    // MARK: 获取 请求结果
    fileprivate func result(_ result: moyaResult) {
        switch result {
        case let .success(response):
            let (isSuccess, tipStr) = response.mapResult()
            print("isSuccess -- \(isSuccess)")
            print("tipStr -- \(tipStr)")
        default: return
        }
    }
    
    // MARK: 获取 模型数组 + 请求结果
    fileprivate func modelsResult(_ result: moyaResult) {
        switch result {
        case let .success(response):
            let (result, models) = response.mapArrayResult(MyModel.self)
            print("isSuccess --\(result.0)")
            print("tipStr --\(result.1)")
            print("models count -- \(models.count)")
        default: return
        }
    }
    
    // MARK: 获取 指定路径的值
    fileprivate func fetchString(_ result: moyaResult) {
        switch result {
        case let .success(response):
            print(response.fetchJSONString())
            print(response.fetchJSONString(keys: ["results", 0]))
            
            print(response.fetchString(keys: [0, "_id"]))
        default: return
        }
    }
    
    // MARK: 使用自定义模型参数类
    fileprivate func customNetParamer(_ result: moyaResult) {
        switch result {
        case let .success(response):
            let (isSuccess, tipStr) = response.mapResult { () -> (ModelableParameterType) in
                return CustomNetParameter()
            }
            print("isSuccess -- \(isSuccess)")
            print("tipStr -- \(tipStr)")
        default: return
        }
    }
    
    // MARK: 其它
    fileprivate func other(_ result: moyaResult) {
        /*
         guard let response = result.value else { return }
         
         response.mapObjResult(MyModel.self)
         response.mapArrayResult(MyModel.self)
         response.mapObject(MyModel.self)
         response.mapObject(MyModel.self, modelKey: "results")
         response.mapArray(MyModel.self, modelKey: "results")
         */
    }
}


// MARK:- 初始化UI
extension NormalMoyaViewController {
    fileprivate func initUI() {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
}

extension NormalMoyaViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = dataArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var completion : Moya.Completion?
        
        if indexPath.row == 0 { // models
            completion = models(_:)
        } else if indexPath.row == 1 { // result
            completion = result(_:)
        } else if indexPath.row == 2 { // modelsResult
            completion = modelsResult(_:)
        } else if indexPath.row == 3 { // fetchString
            completion = fetchString(_:)
        } else if indexPath.row == 4 { // customNetParamer
            completion = customNetParamer(_:)
        }
        
        guard let xCompletion = completion else { return }
        lxfNetTool.request(.data(type: .all, size: 10, index: 1), completion: xCompletion)
    }
}



