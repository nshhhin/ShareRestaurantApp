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
    let imageUrl: String?
    let address: String?
    let tel: String?
    var numberOfStars: Int = 0
    var comment: String?
    
    func coordinate() -> CLLocationCoordinate2D? {
        guard let latitude = latitude,
            let longitude = longitude else {
                return nil
        }
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    init(id: String? = nil,
         name: String? = nil,
         pr: String? = nil,
         latitude: Float? = nil,
         longitude: Float? = nil,
         imageUrl: String? = nil,
         address: String? = nil,
         tel: String? = nil,
         numberOfStars: Int = 0,
         comment: String? = nil) {
        self.id = id
        self.name = name
        self.pr = pr
        self.latitude = latitude
        self.longitude = longitude
        self.imageUrl = imageUrl
        self.address = address
        self.tel = tel
        self.numberOfStars = numberOfStars
        self.comment = comment
    }
}
