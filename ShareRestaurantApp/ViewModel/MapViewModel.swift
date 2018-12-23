//
//  MapViewModel.swift
//  ShareRestaurantApp
//
//  Created by 仲西渉 on 2018/12/24.
//  Copyright © 2018年 WataruNakanishi. All rights reserved.
//

import Foundation
import RxSwift

class MapViewModel {
    
    let gurunaviUseCase = GurunaviUseCase()
    
    func searchRestaurants(latitude: Float, longitude: Float) -> Single<SearchRestaurantResponse> {
        let request = SearchRestaurantRequest(name: nil,
                                              latitude: latitude,
                                              longitude: longitude,
                                              freeword: nil)
        return gurunaviUseCase.searchRestaurants(request)
    }
}
