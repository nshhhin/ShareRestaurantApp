//
//  RestaurantInfoView.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/11.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantInfoView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var restaurantData: Restaurant? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }
    
    func setData(_ restaurant: Restaurant) {
        restaurantData = restaurant
        if let urlStr = restaurant.imageUrl, let url = URL(string: urlStr) {
            imageView.af_setImage(withURL: url)
        }
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
    }
    
    private func configView() {
        let view = Bundle.main.loadNibNamed("RestaurantInfoView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
    }
}
