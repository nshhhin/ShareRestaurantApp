//
//  ApiClient.swift
//  ShareRestaurantApp
//
//  Created by 仲西渉 on 2018/12/16.
//  Copyright © 2018年 WataruNakanishi. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class ApiClient {
    
    let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func get<T: ResponseEntity>(path: String,
                                param: RequestEntity?) -> Single<T> {
        return executeGET(path: path, param: param)
    }
    
    private func executeGET<T: ResponseEntity>(path: String,
                                               param: RequestEntity?) -> Single<T> {
        
        let requestURL = baseURL + path
        
        var requestParameter: Parameters = [:]
        if let param = param {
            requestParameter = param.parameterize()
        }
        
        
        return Single<T>.create { single in
            let manager = SessionManager.default
            let request = manager.request(requestURL,
                                          method: .get,
                                          parameters: requestParameter,
                                          encoding: URLEncoding.default,
                                          headers: nil)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(_):
                        guard let data = response.data else {
                            return single(.error(response.error!))
                        }
                        let json = JSON(data)
                        return single(.success(T(json)))
                    case .failure(let error):
                        return single(.error(error))
                    }
                })
            return Disposables.create {
                return request.cancel()
            }
        }
    }
    
    func post<T: ResponseEntity>(path: String, param: RequestEntity?) -> Single<T> {
        return executePost(path: path, param: param)
    }
    
    private func executePost<T: ResponseEntity>(path: String, param: RequestEntity?) -> Single<T> {
        
        let requestURL = baseURL + path
        
        var requestParameter: Parameters = [:]
        if let param = param {
            requestParameter = param.parameterize()
        }
        
        return Single<T>.create { single in
            let manager = SessionManager()
            let request = manager.request(requestURL,
                                          method: .post,
                                          parameters: requestParameter,
                                          encoding: URLEncoding.default,
                                          headers: nil)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(_):
                        let json = JSON(response.data!)
                        return single(.success(T(json)))
                    case .failure(let error):
                        return single(.error(error))
                    }
                })
            return Disposables.create {
                return request.cancel()
            }
        }
    }
}

extension ApiClient {
    
    func handleErrorResponse(_ response: JSON) -> ApiError? {
        if response["status_code"].int != 200 {
            return ApiError(response)
        }
        return nil
    }
}
