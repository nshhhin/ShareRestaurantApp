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
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var starsView: StarsView!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var restaurantData: Restaurant? = nil
    
    var isSearch: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }
    
    func setData(_ restaurant: Restaurant) {
        resetData()
        restaurantData = restaurant
        if let urlStr = restaurant.imageUrl, let url = URL(string: urlStr) {
            imageView.af_setImage(withURL: url)
        }
        nameLabel.text = restaurant.name
        if isSearch {
            addressLabel.text = restaurant.address
        } else {
            addressLabel.text = restaurant.comment
        }
        
        starsView.setSelectedStars(restaurant.numberOfStars)
    }
    
    private func resetData() {
        restaurantData = nil
        imageView.af_cancelImageRequest()
        imageView.image = nil
        nameLabel.text = nil
        addressLabel.text = nil
    }
    
    private func configView() {
        let view = Bundle.main.loadNibNamed("RestaurantInfoView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
        
        starsView.setStarSize(30.0)
    }
}
