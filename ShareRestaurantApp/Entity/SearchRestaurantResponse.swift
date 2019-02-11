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
    
    let restaurants: [Restaurant]
    
    init(_ json: JSON) {
        self.json = json
        
        let restaurantArray = json["rest"].arrayValue
        
        self.restaurants = restaurantArray.compactMap({ data in
            return Restaurant(id: data["id"].string,
                              name: data["name"].string,
                              pr: data["pr"]["pr_short"].string,
                              latitude: data["latitude"].floatValue,
                              longitude: data["longitude"].floatValue,
                              mobileUrl: data["url_mobile"].string,
                              imageUrl: data["image_url"].string,
                              address: data["address"].string,
                              tel: data["tel"].string,
                              openTime: data["opentime"].string,
                              holiday: data["holiday"].string)
        })
    }
    
}
