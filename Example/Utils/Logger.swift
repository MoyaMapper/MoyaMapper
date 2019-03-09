//
//  Logger.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/10/22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

let log = Logger.shared

final class Logger {
    static let shared = Logger()
    private init() { }
    
    static let logDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return f
    }()
}

extension Logger {
    func error<T>(
        _ message : T,
        file : StaticString = #file,
        function : StaticString = #function,
        line : UInt = #line
    ) {
        LXFLog(message, type: .error, file : file, function: function, line: line)
    }
    
    func warning<T>(
        _ message : T,
        file : StaticString = #file,
        function : StaticString = #function,
        line : UInt = #line
    ) {
        LXFLog(message, type: .warning, file : file, function: function, line: line)
    }
    
    func info<T>(
        _ message : T,
        file : StaticString = #file,
        function : StaticString = #function,
        line : UInt = #line
    ) {
        LXFLog(message, type: .info, file : file, function: function, line: line)
    }
    
    func debug<T>(
        _ message : T,
        file : StaticString = #file,
        function : StaticString = #function,
        line : UInt = #line
    ) {
        LXFLog(message, type: .debug, file : file, function: function, line: line)
    }
}

enum LogType: String {
    case error = "❤️ ERROR"
    case warning = "💛 WARNING"
    case info = "💙 INFO"
    case debug = "💚 DEBUG"
}


// MARK:- 自定义打印方法
// target -> Build Settings 搜索 Other Swift Flags
// 设置Debug 添加 -D DEBUG
func LXFLog<T>(
    _ message : T,
    type: LogType,
    file : StaticString = #file,
    function : StaticString = #function,
    line : UInt = #line
) {
    #if DEBUG
    let time = Logger.logDateFormatter.string(from: Date())
    let fileName = (file.description as NSString).lastPathComponent
    print("\(time) \(type.rawValue) \(fileName):(\(line))-\(message)")
    #endif
}
