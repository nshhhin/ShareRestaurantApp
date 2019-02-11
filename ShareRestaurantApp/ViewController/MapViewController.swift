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
    
    // MARK: IBOutlet
    @IBOutlet weak var searchCurrentLocationButton: UIButton!
    
    @IBOutlet weak var searchCenterLocationButton: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: Private Property
    private let defaultPosition = CLLocationCoordinate2D(latitude: 35.6811716, longitude: 139.7648629)
    
    private let defaultZoom: Float = 17.0
    
    private let viewModel = MapViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var restaurants = [Restaurant]()
    
    private var location: CLLocation? = nil
    
    // MARK: - Tap Action
    @IBAction func onClickSearchCurrentLocation(_ sender: UIButton) {
        guard let location = location else {
            viewModel.requestFetchLocation()
            return
        }
        searchRestaurant(location.coordinate)
    }
    
    @IBAction func onClickSearchCenterLocation(_ sender: UIButton) {
        let centerLocation = mapView.camera.target
        searchRestaurant(centerLocation)
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
        
        var currentLocation: CLLocationCoordinate2D
        if let current = location {
            currentLocation = current.coordinate
        } else {
            currentLocation = defaultPosition
        }
        let camera = GMSCameraPosition.camera(withTarget: currentLocation,
                                              zoom: defaultZoom)
        mapView.camera = camera
    }
    /// 位置情報関係の初期設定
    private func configLocation() {
        viewModel.bindLocation
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] currentLocation in
                self?.location = currentLocation
            }).disposed(by: disposeBag)
        
        viewModel.bindFetchLocationError
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { locationError in
                // TODO: エラー処理
                switch locationError {
                case .disallowFetchLocation:
                    print("許可されていない")
                case .failedFetchLocation:
                    print("取得失敗")
                case .unknown:
                    print("その他")
                }
            }).disposed(by: disposeBag)
        viewModel.startFetchLocation()
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
                self?.updateCameraPosition(current: location)
            }).disposed(by: disposeBag)
    }
    /// レストラン情報を元にマーカーを表示
    private func showMarker() {
        for restaurant in restaurants {
            guard let position = restaurant.coordinate() else {
                continue
            }
            let marker = GMSMarker()
            marker.position = position
            marker.title = restaurant.name
            marker.map = mapView
        }
    }
    /// レストランが全て画面に収まるように表示を変更
    private func updateCameraPosition(current location: CLLocationCoordinate2D?) {
        var bounds = GMSCoordinateBounds()
        if let location = location {
            bounds.includingCoordinate(location)
        }
        for restaurant in restaurants {
            guard let coordinate = restaurant.coordinate() else{
                continue
            }
            bounds = bounds.includingCoordinate(coordinate)
        }
        
        let updateCamera = GMSCameraUpdate.fit(bounds, withPadding: 16)
        mapView.animate(with: updateCamera)
    }
}
