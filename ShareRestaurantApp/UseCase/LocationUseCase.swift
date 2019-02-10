//
//  LocationUseCase.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/09.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class LocationUseCase: NSObject {
    
    private let locationManager = CLLocationManager()
    /// 位置情報を監視
    var bindLocation: BehaviorSubject<CLLocation?> = BehaviorSubject(value: nil)
    /// 位置情報取得エラー
    var bindLocationError: BehaviorSubject<Error?> = BehaviorSubject(value: nil)
    /// 位置情報を1度だけ取得
    func fetchLocationOnce() {
        guard let location = locationManager.location else {
            locationManager.delegate = self
            locationManager.requestLocation()
            return
        }
        bindLocation.onNext(location)
    }
    /// 位置情報を断続的に取得
    func fetchLocationIntermittent() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func autholizeLocation(completion: @escaping () -> Void) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            completion()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // TODO: bindLocationError.onNext()
            break
        }
    }
}

extension LocationUseCase: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        bindLocation.onNext(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TOOD: エラー処理
    }
}
