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

    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedStoreButton(_ sender: UIButton) {
        saveFavariteRestaurant()
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
    }
    
    private func saveFavariteRestaurant() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
