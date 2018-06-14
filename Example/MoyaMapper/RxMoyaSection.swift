//
//  RxMoyaSection.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import RxDataSources

enum RxMoyaSection {
    case requests([RxMoyaSectionItem])
}

extension RxMoyaSection: SectionModelType {
    init(original: RxMoyaSection, items: [RxMoyaSectionItem]) {
        switch original {
        case .requests: self = .requests(items)
        }
    }
    
    var items: [RxMoyaSectionItem] {
        switch self {
        case .requests(let items): return items
        }
    }
}

enum RxMoyaSectionItem {
    case models
    case result
    case modelsResult
    case fetchString
    case customNetParamer
}
