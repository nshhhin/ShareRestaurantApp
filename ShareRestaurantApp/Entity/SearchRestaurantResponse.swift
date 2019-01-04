//
//  SearchRestaurantResponse.swift
//  ShareRestaurantApp
//
//  Created by 仲西渉 on 2018/12/16.
//  Copyright © 2018年 WataruNakanishi. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

struct SearchRestaurantResponse: ResponseEntity {
    
    var json: JSON
    
    struct Restaurant {
        let id: String
        let name: String
        let pr: String?
        let latitude: Float
        let longitude: Float
        let mobileUrl: String
        let imageUrl: String?
        let address: String?
        let tel: String?
        let openTime: String?
        let holiday: String?
        
        func coordinate() -> CLLocationCoordinate2D {
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
    }
    
    let restaurants: [Restaurant]
    
    init(_ json: JSON) {
        self.json = json
        
        let restaurantArray = json["rest"].arrayValue
        
        self.restaurants = restaurantArray.compactMap({ data in
            return Restaurant(id: data["id"].stringValue,
                              name: data["name"].stringValue,
                              pr: data["pr"]["pr_short"].string,
                              latitude: data["latitude"].floatValue,
                              longitude: data["longitude"].floatValue,
                              mobileUrl: data["url_mobile"].stringValue,
                              imageUrl: data["image_url"].string,
                              address: data["address"].string,
                              tel: data["tel"].string,
                              openTime: data["opentime"].string,
                              holiday: data["holiday"].string)
        })
    }
    
}
