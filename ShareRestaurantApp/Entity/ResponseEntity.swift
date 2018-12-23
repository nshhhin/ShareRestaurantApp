//
//  ResponseEntity.swift
//  ShareRestaurantApp
//
//  Created by 仲西渉 on 2018/12/16.
//  Copyright © 2018年 WataruNakanishi. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ResponseEntity {
    var json: JSON { get }
    init(_ json: JSON)
}
