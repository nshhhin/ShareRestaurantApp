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
    
    @IBOutlet weak var searchCurrentLocationButton: UIButton!
    
    @IBOutlet weak var searchCenterLocationButton: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var locationManager = CLLocationManager()
    
    private let defaultPosition = CLLocationCoordinate2D(latitude: 35.6811716, longitude: 139.7648629)
    
    private let defaultZoom: Float = 17.0
    
    private let viewModel = MapViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var restaurants = [SearchRestaurantResponse.Restaurant]()
    
    // MARK: - Tap Action
    @IBAction func onClickSearchCurrentLocation(_ sender: UIButton) {
        guard let location = locationManager.location else {
            locationManager.requestLocation()
            return
        }
        searchRestaurant(location.coordinate)
    }
    
    @IBAction func onClickSearchCenterLocation(_ sender: UIButton) {
        let location = mapView.camera.target
        searchRestaurant(location)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configLocation()
        configMap()
    }
    
    // MARK: - Private Method
    /// Viewのレイアウト等の初期設定
    private func configView() {
        searchCurrentLocationButton.layer.cornerRadius = 15.0
        searchCenterLocationButton.layer.cornerRadius = 15.0
    }
    
    /// Mapのの初期設定
    private func configMap() {
        mapView.isMyLocationEnabled = true
        
        var location: CLLocationCoordinate2D
        if let current = locationManager.location {
            location = current.coordinate
        } else {
            location = defaultPosition
        }
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: defaultZoom)
        mapView.camera = camera
    }
    /// 位置情報関係の初期設定
    private func configLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // TODO: 設定アプリを開く
            break
        }
    }
    /// レストラン検索
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
                self?.updateCameraPosition(location)
            }).disposed(by: disposeBag)
    }
    /// レストラン情報を元にマーカーを表示
    private func showMarker() {
        for restaurant in restaurants {
            let marker = GMSMarker()
            
            marker.position = restaurant.coordinate()
            marker.title = restaurant.name
            marker.map = mapView
        }
    }
    /// レストランが全て画面に収まるように表示を変更
    private func updateCameraPosition(_ location: CLLocationCoordinate2D) {
        var bounds = GMSCoordinateBounds()
        for restaurant in restaurants {
            bounds = bounds.includingCoordinate(restaurant.coordinate())
        }
        
        let updateCamera = GMSCameraUpdate.fit(bounds, withPadding: 16)
        mapView.animate(with: updateCamera)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: 位置情報が更新された際の処理（必要であれば）
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        // TODO: 位置情報再取得の処理
    }
}
