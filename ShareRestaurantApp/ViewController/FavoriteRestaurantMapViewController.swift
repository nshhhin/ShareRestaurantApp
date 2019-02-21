//
//  FavoriteRestaurantMapViewController.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/19.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMaps
import CoreLocation

class FavoriteRestaurantMapViewController: UIViewController {
    
    static let storyboardId = "FavoriteRestaurantMapViewController"
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var restaurantInfoView: RestaurantInfoView!
    @IBOutlet weak var restaurantInfoViewBottom: NSLayoutConstraint!
    
    // MARK: - Private Property
    private let infoViewHeight: CGFloat = 120
    private let defaultMargin: CGFloat = 16
    private var safeAreaInsetBottom: CGFloat = 0
    private var restaurants = [Restaurant]()
    private let defaultPosition = CLLocationCoordinate2D(latitude: 35.6811716, longitude: 139.7648629)
    private let defaultZoom: Float = 17.0
    private let disposeBag = DisposeBag()
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillLayoutSubviews() {
        safeAreaInsetBottom = view.safeAreaInsets.bottom
    }
    
    // MARK: - Publich Methods
    func setFavoriteRestaurant(_ restaurants: [Restaurant]) {
        self.restaurants = restaurants
    }
    
    // MARK: - Private Methods
    private func configView() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(10, maxZoom: 19)
        updateCameraPosition()
        
        restaurantInfoView.storeButton.isHidden = true
        restaurantInfoView.isSearch = false
        restaurantInfoView.starsView.isUserInteractionEnabled = false
        restaurantInfoView.setShadow()
        
        restaurantInfoView.closeButton
            .rx.tap.subscribe { [weak self] _ in
                self?.closeInfoView()
            }.disposed(by: disposeBag)
        
        for restaurant in restaurants {
            guard let coordinate = restaurant.coordinate() else {
                continue
            }
            let marker = GMSMarker()
            marker.position = coordinate
            // マーカーとレストラン情報を紐づけるために title に id を設定
            marker.title = restaurant.id
            marker.map = mapView
        }
        
        if restaurants.count == 1 {
            showInfoView(selected: restaurants.first!)
            restaurantInfoView.closeButton.isHidden = true
        }
    }
    
    private func updateCameraPosition() {
        var bounds = GMSCoordinateBounds()
        if let myLocation = mapView.myLocation {
            bounds.includingCoordinate(myLocation.coordinate)
        }
        for restaurant in restaurants {
            guard let coordinate = restaurant.coordinate() else {
                continue
            }
            bounds = bounds.includingCoordinate(coordinate)
        }
        let updateCamera = GMSCameraUpdate.fit(bounds, withPadding: 16)
        mapView.animate(with: updateCamera)
    }
    
    // MARK: - Fileprivate Method
    fileprivate func showInfoView(selected restaurant: Restaurant) {
        restaurantInfoView.setData(restaurant)
        restaurantInfoViewBottom.constant = safeAreaInsetBottom + defaultMargin
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func closeInfoView() {
        restaurantInfoViewBottom.constant -= (infoViewHeight + safeAreaInsetBottom + defaultMargin)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func searchSelectedRestaurant(id: String) -> Restaurant? {
        for restaurant in restaurants {
            if restaurant.id == id {
                return restaurant
            }
        }
        return nil
    }

}

extension FavoriteRestaurantMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        // TODO: マーカーとレストランの連携方法を再検討
        guard let id = marker.title,
            let restaurant = searchSelectedRestaurant(id: id) else {
                return true
        }
        showInfoView(selected: restaurant)
        return true
    }
}
