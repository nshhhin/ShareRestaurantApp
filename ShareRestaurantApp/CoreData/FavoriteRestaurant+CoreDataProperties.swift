//
//  FavoriteRestaurant+CoreDataProperties.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/11.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteRestaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRestaurant> {
        return NSFetchRequest<FavoriteRestaurant>(entityName: "FavoriteRestaurant")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var comment: String?
    @NSManaged public var userId: String?
    @NSManaged public var numberOfStars: Int16
    @NSManaged public var genre: String?
    @NSManaged public var imageUrlStr: String?
    @NSManaged public var address: String?
    @NSManaged public var telNumber: String?

}
