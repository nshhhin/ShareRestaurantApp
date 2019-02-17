//
//  FavoriteRestaurant+CoreDataClass.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/11.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FavoriteRestaurant)
public class FavoriteRestaurant: NSManagedObject {
    
    func toRestaurant() -> Restaurant {
        return Restaurant(id: id,
                          name: name,
                          pr: pr,
                          latitude: latitude,
                          longitude: longitude,
                          imageUrl: imageUrlStr,
                          address: address,
                          tel: telNumber,
                          numberOfStars: Int(numberOfStars),
                          comment: comment)
    }
}
