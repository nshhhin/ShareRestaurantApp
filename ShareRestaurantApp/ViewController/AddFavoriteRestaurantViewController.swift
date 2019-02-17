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

    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    
    @IBOutlet weak var starsView: StarsView!
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        delegate?.tappedCloseButton()
    }
    
    @IBAction func tappedStoreButton(_ sender: UIButton) {
        guard var restaurant = restaurant else {
            // TODO: 来ない想定だが、念のためエラー処理
            return
        }
        restaurant.comment = commentTextView.text
        restaurant.numberOfStars = starsView.lastSelectedTag ?? 0
        delegate?.tappedStoreButton(restaurant)
    }
    
    var restaurant: Restaurant? = nil
    
    var delegate: AddFavoriteRestaurantViewControllerDelegate? = nil
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    // MARK: - Public Method
    func setRestaurant(selected selectedRestaurant: Restaurant) {
        restaurant = selectedRestaurant
    }
    
    // MARK: - Private Method
    private func configView() {
        restaurantName.text = restaurant?.name
        // TODO: 保存していた評価を反映
        starsView.setSelectedStars(nil)
        commentTextView.delegate = self
    }

}

extension AddFavoriteRestaurantViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 改行が入力されたらキーボードを下げる
        guard text == "\n" else {
            return true
        }
        commentTextView.resignFirstResponder()
        return false
    }
}

extension AddFavoriteRestaurantViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text == "\n" else {
            return true
        }
        commentTextView.resignFirstResponder()
        return false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
