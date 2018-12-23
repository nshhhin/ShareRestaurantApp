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
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var locationManager = CLLocationManager()
    
    private let defaultPosition = CLLocationCoordinate2D(latitude: 35.6811716, longitude: 139.7648629)
    
    private let defaultZoom: Float = 15.0
    
    private let viewModel = MapViewModel()
    
    private let disposeBag = DisposeBag()

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
        locationManager.requestWhenInUseAuthorization()
        let camera = GMSCameraPosition.camera(withTarget: defaultPosition, zoom: defaultZoom)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
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
        viewModel.searchRestaurants(latitude: Float(location.coordinate.latitude),
                                    longitude: Float(location.coordinate.longitude))
            .asDriver(onErrorRecover: { error in
                print(error)
                return Driver.empty()
            }).drive(onNext: { response in
                print(response)
            }).disposed(by: disposeBag)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        // TODO: 位置情報再取得の処理
    }
}
