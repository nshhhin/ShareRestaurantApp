//
//  UIView+Shadow.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/13.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setShadow(size: CGSize = CGSize(width: 0, height: 2),
                   opacity: Float = 0.6,
                   radius: CGFloat = 4) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = size
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}
