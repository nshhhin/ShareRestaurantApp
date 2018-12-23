//
//  MapViewController.swift
//  ShareRestaurantApp
//
//  Created by 仲西渉 on 2018/11/11.
//  Copyright © 2018年 WataruNakanishi. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var locationManager = CLLocationManager()
    
    private let defaultPosition = CLLocationCoordinate2D(latitude: 35.6811716, longitude: 139.7648629)
    
    private let defaultZoom: Float = 17.0
    
    private let viewModel = MapViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var restaurants = [SearchRestaurantResponse.Restaurant]()
    
    @IBAction func onClickSearch(_ sender: UIButton) {
        guard let location = locationManager.location else {
            locationManager.requestLocation()
            return
        }
        searchRestaurant(location.coordinate)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configMap()
    }
    
    /// Viewのレイアウト等の設定
    private func configView() {
        locationManager.delegate = self
    }
    
    /// Mapのの初期設定
    private func configMap() {
        searchButton.layer.cornerRadius = 15.0
        mapView.isMyLocationEnabled = true
        
        guard let location = locationManager.location else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: defaultZoom)
        mapView.camera = camera
    }
    
    private func showMarker() {
        for restaurant in restaurants {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(restaurant.latitude),
                                                     longitude: CLLocationDegrees(restaurant.longitude))
            marker.title = restaurant.name
            marker.map = mapView
        }
    }
    
    private func searchRestaurant(_ location: CLLocationCoordinate2D) {
        viewModel.searchRestaurants(latitude: Float(location.latitude),
                                    longitude: Float(location.longitude))
            .asDriver(onErrorRecover: { error in
                // TODO: エラー処理
                print(error)
                return Driver.empty()
            }).drive(onNext: { [weak self] response in
                self?.restaurants = response.restaurants
                self?.showMarker()
            }).disposed(by: disposeBag)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // TODO: 設定アプリを開く
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let cameraPosition = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: defaultZoom)
        mapView.camera = cameraPosition
        searchRestaurant(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        // TODO: 位置情報再取得の処理
    }
}
