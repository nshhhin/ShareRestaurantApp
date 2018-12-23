//
//  GurunaviUseCase.swift
//  ShareRestaurantApp
//
//  Created by 仲西渉 on 2018/12/16.
//  Copyright © 2018年 WataruNakanishi. All rights reserved.
//

import Foundation
import RxSwift

class GurunaviUseCase {
    
    let apiClient = ApiClient(baseURL: GURUNAVI_BASE_API_URL)
    
    func searchRestaurants(_ request: SearchRestaurantRequest) -> Single<SearchRestaurantResponse> {
        return apiClient.get(path: GURUNAVI_SEARCH_RESTAURANT_API_PATH + GURUNAVI_API_VERSION,
                             param: request)
    }
}
