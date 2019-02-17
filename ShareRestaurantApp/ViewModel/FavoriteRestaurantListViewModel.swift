//
//  FavoriteRestaurantListViewModel.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/17.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import Foundation
import RxSwift

final class FavoriteRestaurantListViewModel {
    
    var bindFavoriteRestaurants: BehaviorSubject<[FavoriteRestaurant]> {
        return CoreDataUseCase.shared.bindFavoriteRestaurantsData
    }
    
    func loadFavoriteRestaurant() {
        CoreDataUseCase.shared.fetchContext()
    }
}
