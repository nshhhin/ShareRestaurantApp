//
//  ApiError.swift
//  ShareRestaurantApp
//
//  Created by 仲西渉 on 2018/12/22.
//  Copyright © 2018年 WataruNakanishi. All rights reserved.
//

import Foundation
import SwiftyJSON

class ApiError: Error {
    
    let status: Int
    
    let errors: [Any]?
    
    init(_ json: JSON) {
        self.status = json["status_code"].intValue
        self.errors = json["errors"].arrayObject
    }
}



