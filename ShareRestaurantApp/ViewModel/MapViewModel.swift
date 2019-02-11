//
//  MapViewModel.swift
//  ShareRestaurantApp
//
//  Created by 仲西渉 on 2018/12/24.
//  Copyright © 2018年 WataruNakanishi. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class MapViewModel {
    
    let gurunaviUseCase = GurunaviUseCase()
    
    let locationUseCase = LocationUseCase()
    
    var bindLocation: BehaviorSubject<CLLocation?> {
        return locationUseCase.bindLocation
    }
    
    var bindFavoriteRestaurants: BehaviorSubject<[FavoriteRestaurant]> {
        return CoreDataUseCase.shared.bindFavoriteRestaurantsData
    }
    
    var bindFetchLocationError: BehaviorSubject<LocationError> {
        return locationUseCase.bindLocationError
    }
    
    func searchRestaurants(latitude: Float, longitude: Float) -> Single<SearchRestaurantResponse> {
        let request = SearchRestaurantRequest(name: nil,
                                              latitude: latitude,
                                              longitude: longitude,
                                              freeword: nil)
        return gurunaviUseCase.searchRestaurants(request)
    }
    
    func startFetchLocation() {
        locationUseCase.fetchLocationIntermittent()
    }
    
    func requestFetchLocation() {
        locationUseCase.fetchLocationOnce()
    }
    
    func loadFavoriteRestaurants() {
        CoreDataUseCase.shared.fetchContext()
    }
    
    func saveFavoriteRestaurant(_ restaurant: Restaurant) {
        CoreDataUseCase.shared.storeContext(restaurant: restaurant)
    }
}
