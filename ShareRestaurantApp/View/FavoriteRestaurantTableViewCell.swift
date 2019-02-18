//
//  FavoriteRestaurantTableViewCell.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/17.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import UIKit
import AlamofireImage

class FavoriteRestaurantTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "favoriteRestaurantCell"
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var starsView: StarsView!
    
    private var restaurant: Restaurant? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    override func prepareForReuse() {
        thumbnailView.af_cancelImageRequest()
        thumbnailView.image = nil
        nameLabel.text = nil
        commentLabel.attributedText = nil
        starsView.setSelectedStars(nil)
    }

    func setRestaurant(_ restaurant: Restaurant) {
        self.restaurant = restaurant
        if let urlStr = restaurant.imageUrl, let url = URL(string: urlStr) {
            thumbnailView.af_setImage(withURL: url)
        }
        nameLabel.text = restaurant.name
        if let comment = restaurant.comment {
            commentLabel.attributedText = NSAttributedString(string: comment)
        }
        starsView.setSelectedStars(restaurant.numberOfStars)
    }
    
    func configView() {
        starsView.isUserInteractionEnabled = false
        thumbnailView.image = nil
        nameLabel.text = nil
        commentLabel.attributedText = nil
    }
    
}
