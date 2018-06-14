//
//  UITableView+Rx.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

extension Reactive where Base: UITableView {
    func itemSelected<S>(dataSource: TableViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
        let source = self.itemSelected.map { indexPath in
            dataSource[indexPath]
        }
        return ControlEvent(events: source)
    }
}

