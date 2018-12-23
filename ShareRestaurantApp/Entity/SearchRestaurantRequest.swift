//
//  SearchRestaurantRequest.swift
//  ShareRestaurantApp
//
//  Created by 仲西渉 on 2018/12/16.
//  Copyright © 2018年 WataruNakanishi. All rights reserved.
//

import Foundation

struct SearchRestaurantRequest: RequestEntity {
    
    enum Range: Int {
        case threeHundred = 1
        case fiveHundred = 2
        case thousand = 3
        case twoThousand = 4
        case threeThousand = 5
    }
    
    /// フリーワード検索の条件
    enum FreewordCondition: Int {
        /// AND検索
        case and = 1
        /// OR検索
        case or = 2
    }
    
    let keyid: String
    
    let name: String?
    
    let latitude: Float
    
    let longitude: Float
    
    let range: Range
    
    let hitCount: Int
    
    let freeword: String?
    
    let freewordCondition: FreewordCondition
    
    init(name: String?, latitude: Float, longitude: Float, range: Range = Range.threeHundred, hitCount: Int = 30, freeword: String?, freewordCondition: FreewordCondition = FreewordCondition.and) {
        self.keyid = GURUNAVI_API_KEY
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.range = range
        self.hitCount = hitCount
        self.freeword = freeword
        self.freewordCondition = freewordCondition
    }
    
    func parameterize() -> [String : Any] {
        var params = [String: Any]()
        
        params["keyid"] = keyid
        
        if let name = name {
            params["name"] = name
        }
        
        params["latitude"] = latitude
        
        params["longitude"] = longitude
        
        params["range"] = range.rawValue
        
        if let freeword = freeword {
            params["freeword"] = freeword
        }
        
        params["freeword_condition"] = freewordCondition.rawValue
        
        return params
    }
}
