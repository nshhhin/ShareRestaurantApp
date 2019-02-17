//
//  CoreDataUseCase.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/11.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class CoreDataUseCase {
    
    static let shared = CoreDataUseCase()
    
    var persistentContainer: NSPersistentContainer!
    
    private var favoriteRestaurants = [FavoriteRestaurant]()
    
    var bindFavoriteRestaurantsData: BehaviorSubject<[FavoriteRestaurant]> = BehaviorSubject(value: [])
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: "FavoriteRestaurants")
        self.persistentContainer.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        })
    }
    
    func fetchContext() {
        let manageContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteRestaurant> = FavoriteRestaurant.fetchRequest()
        do {
            let fetchedData = try manageContext.fetch(fetchRequest)
            favoriteRestaurants = fetchedData
            bindFavoriteRestaurantsData.onNext(favoriteRestaurants)
        } catch let error as NSError {
            print("could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func storeContext(restaurant: Restaurant?) {
        let context = persistentContainer.viewContext
        if let restaurant = restaurant {
            appendFavoriteRestaurant(restaurant, context: context)
        }
        if context.hasChanges {
            do {
                try context.save()
                bindFavoriteRestaurantsData.onNext(favoriteRestaurants)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func appendFavoriteRestaurant(_ restaurant: Restaurant, context: NSManagedObjectContext) {
        let favoResataurant = FavoriteRestaurant(context: context)
        favoResataurant.id = restaurant.id
        favoResataurant.name = restaurant.name
        if let lat = restaurant.longitude, let long = restaurant.longitude {
            favoResataurant.latitude = lat
            favoResataurant.longitude = long
        }
        favoResataurant.comment = restaurant.comment
        // TODO: ここは修正
        favoResataurant.userId = "testUser"
        favoResataurant.numberOfStars = Int16(restaurant.numberOfStars)
        // TODO: ジャンルは取得、保存するのか再検討
        favoResataurant.genre = ""
        favoResataurant.imageUrlStr = restaurant.imageUrl
        favoResataurant.address = restaurant.address
        favoResataurant.telNumber = restaurant.tel
        
        favoriteRestaurants.append(favoResataurant)
    }
}
