//
//  Restaurant.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/10.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import Foundation
import CoreLocation

struct Restaurant {
    let id: String?
    let name: String?
    let pr: String?
    let latitude: Float?
    let longitude: Float?
    let mobileUrl: String?
    let imageUrl: String?
    let address: String?
    let tel: String?
    let openTime: String?
    let holiday: String?
    
    func coordinate() -> CLLocationCoordinate2D? {
        guard let latitude = latitude,
            let longitude = longitude else {
                return nil
        }
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
