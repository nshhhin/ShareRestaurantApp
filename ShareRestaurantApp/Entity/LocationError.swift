//
//  LocationError.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/10.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import Foundation

enum LocationError: Error {
    
    case disallowFetchLocation
    case failedFetchLocation
    case unknown
}
