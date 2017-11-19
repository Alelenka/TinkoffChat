//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 19.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

//struct RequestConfig<Parser> where Parser: IParser {
//    let request: IRequest
//    let parser: Parser
//}

struct RequestConfig<Model> {
    let request: IRequest
    let parser: Parser<Model>
}

enum Result<T> {
    case success(T)
    case error(String)
}

protocol IRequestSender {
//    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void)
    func send<Model>(config: RequestConfig<Model>, completionHandler: @escaping (Result<Model>) -> Void)
}

class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
//    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) {
    func send<Model>(config: RequestConfig<Model>, completionHandler: @escaping (Result<Model>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("ulr string can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            
            guard let data = data,
                let parseModel: Model = config.parser.parse(data: data) else {
                    completionHandler(Result.error("recieved data can't be parsed"))
                    return
            }
            
            completionHandler(Result.success(parseModel))
        }
        
        task.resume()
    }
    
}
