//
//  Networking.swift
//  MoyaMapper_Example
//
//  Created by LinXunFeng on 2018/10/22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Moya
import RxSwift
import MoyaMapper

typealias GankNetworking = Networking<GankApi>
typealias TypicodeNetworking = Networking<TypicodeApi>

final class Networking<Target: SugarTargetType>: MoyaSugarProvider<Target> {
    init(plugins: [PluginType] = []) {
        let configuration = URLSessionConfiguration.default
        let session = Session(configuration: configuration, startRequestsImmediately: false)
        super.init(session: session, plugins: plugins)
    }
    
    func request(
        _ target: Target,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) -> Single<Response> {
        let requestString = "\(target.baseURL.absoluteString) \(target.method) \(target.path)"
        
        return self.rx.request(target)
            .do(
                onSuccess: { (value) in
                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                    log.debug(message, file: file, function: function, line: line)
            },
                onError: { [weak self] (error) in
                    self?.logError(error, requestString: requestString, file: file, function: function, line: line)
                },
                onSubscribe: nil,
                onSubscribed: {
                    let message = "REQUEST: \(requestString)"
                    log.debug(message, file: file, function: function, line: line)
            },
                onDispose: nil)
    }
    
    func cacheRequest(
        _ target: Target,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) -> Observable<Response> {
        let requestString = "\(target.baseURL.absoluteString) \(target.method) \(target.path)"
        
        return self.rx.cacheRequest(target)
            .do(onNext: { value in
                let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                log.debug(message, file: file, function: function, line: line)
            }, onError: { [weak self] error in
                self?.logError(error, requestString: requestString, file: file, function: function, line: line)
                }, onCompleted: nil, onSubscribe: nil, onSubscribed: {
                    let message = "REQUEST: \(requestString)"
                    log.debug(message, file: file, function: function, line: line)
            }, onDispose: nil)
    }
    
    func logError(_ error : Error,
                  requestString: String,
                  file: StaticString = #file,
                  function: StaticString = #function,
                  line: UInt = #line) {
        if let response = (error as? MoyaError)?.response {
            if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                log.warning(message, file: file, function: function, line: line)
            } else if let rawString = String(data: response.data, encoding: .utf8) {
                let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                log.warning(message, file: file, function: function, line: line)
            } else {
                let message = "FAILURE: \(requestString) (\(response.statusCode))"
                log.warning(message, file: file, function: function, line: line)
            }
        } else {
            let message = "FAILURE: \(requestString)\n\(error)"
            log.warning(message, file: file, function: function, line: line)
        }
    }
}
