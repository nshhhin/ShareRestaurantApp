//
//  MapViewController.swift
//  ShareRestaurantApp
//
//  Created by 仲西渉 on 2018/11/11.
//  Copyright © 2018年 WataruNakanishi. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private let defaultPosition = CLLocationCoordinate2D(latitude: 35.6811716, longitude: 139.7648629)
    
    private let defaultZoom: Float = 15.0

    override func viewDidLoad() {
        super.viewDidLoad()
        configMap()
    }
    
    private func configMap() {
        let camera = GMSCameraPosition.camera(withTarget: defaultPosition, zoom: defaultZoom)
        mapView.camera = camera
    }
}

