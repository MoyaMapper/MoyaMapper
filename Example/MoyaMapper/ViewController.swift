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
import SwiftyJSON
class ViewController: BaseViewController {
    
    let dataArray = ["普通Moya网络请求", "RxMoya网络请求", "模型嵌套解析", "Cache"]

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
}


// MARK:- 初始化UI
extension ViewController {
    fileprivate func initUI() {
        self.title = "MoyaMapper"
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
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
        var vc: UIViewController?
        if indexPath.row == 0 {
            vc = NormalMoyaViewController()
        } else if indexPath.row == 1 {
            vc = RxMoyaViewController()
        } else if indexPath.row == 2 {
            vc = MultipleModelViewController()
        } else if indexPath.row == 3 {
            vc = CacheViewController()
        }
        
        if vc == nil { return }
        vc?.title = dataArray[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

