//
//  FavoriteRestaurantMapViewController.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/19.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class FavoriteRestaurantMapViewController: UIViewController {
    
    static let storyboardId = "FavoriteRestaurantMapViewController"
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var restaurantInfoView: RestaurantInfoView!
    
    // MARK: - Private Property
    private var restaurant: Restaurant? = nil
    private let defaultPosition = CLLocationCoordinate2D(latitude: 35.6811716, longitude: 139.7648629)
    private let defaultZoom: Float = 17.0
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    // MARK: - Publich Methods
    func setFavoriteRestaurant(_ restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    // MARK: - Private Methods
    private func configView() {
        restaurantInfoView.starsView.isUserInteractionEnabled = false
        
        guard let restaurant = restaurant,
            let coordinate = restaurant.coordinate() else {
                restaurantInfoView.isHidden = true
                return
        }
        restaurantInfoView.setShadow()
        restaurantInfoView.closeButton.isHidden = true
        restaurantInfoView.storeButton.isHidden = true
        restaurantInfoView.setData(restaurant)
        
        mapView.isMyLocationEnabled = true
        let cameraUpdate = GMSCameraUpdate.setTarget(coordinate,
                                                     zoom: defaultZoom)
        mapView.moveCamera(cameraUpdate)
        
        let marker = GMSMarker()
        marker.position = coordinate
        marker.map = mapView
    }

}
