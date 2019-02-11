//
//  AddFavoriteRestaurantViewController.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/11.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddFavoriteRestaurantViewControllerDelegate {
    func tappedCloseButton()
    func tappedStoreButton(_ restaurant: Restaurant)
}

class AddFavoriteRestaurantViewController: UIViewController {
    
    static let storyboardId = "AddFavoriteRestaurantViewController"

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    
    var restaurant: Restaurant? = nil
    
    var delegate: AddFavoriteRestaurantViewControllerDelegate? = nil
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.rx.tap.subscribe { [weak self] _ in
            self?.delegate?.tappedCloseButton()
        }.disposed(by: disposeBag)
        
        storeButton.rx.tap.subscribe { [weak self] _ in
            guard let restaurant = self?.restaurant else {
                return
            }
            self?.delegate?.tappedStoreButton(restaurant)
        }.disposed(by: disposeBag)
    }
    
    func setRestaurant(selected selectedRestaurant: Restaurant) {
        restaurant = selectedRestaurant
    }

}
