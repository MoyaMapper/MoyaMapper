//
//  NormalMoyaViewController.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import Moya
import Result
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
        guard let response = result.value else { return }
        let models = response.mapArray(MyModel.self)
        for model in models {
            print("id -- \(model._id)")
        }
    }
    
    // MARK: 获取 请求结果
    fileprivate func result(_ result: moyaResult) {
        guard let response = result.value else { return }
        let (isSuccess, tipStr) = response.mapResult()
        print("isSuccess -- \(isSuccess)")
        print("tipStr -- \(tipStr)")
    }
    
    // MARK: 获取 模型数组 + 请求结果
    fileprivate func modelsResult(_ result: moyaResult) {
        guard let response = result.value else { return }
        let (result, models) = response.mapArrayResult(MyModel.self)
        print("isSuccess --\(result.0)")
        print("tipStr --\(result.1)")
        print("models count -- \(models.count)")
    }
    
    // MARK: 获取 指定路径的值
    fileprivate func fetchString(_ result: moyaResult) {
        guard let response = result.value else { return }
        print(response.fetchJSONString())
        print(response.fetchJSONString(keys: [0]))
        
        print(response.fetchString(keys: [0, "_id"]))
    }
    
    // MARK: 使用自定义模型参数类
    fileprivate func customNetParamer(_ result: moyaResult) {
        guard let response = result.value else { return }
        let (isSuccess, tipStr) = response.mapResult { () -> (ModelableParameterType.Type) in
            return CustomNetParameter.self
        }
        print("isSuccess -- \(isSuccess)")
        print("tipStr -- \(tipStr)")
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



