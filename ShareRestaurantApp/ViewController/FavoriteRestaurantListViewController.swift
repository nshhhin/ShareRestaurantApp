//
//  FavoriteRestaurantListViewController.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/17.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteRestaurantListViewController: UIViewController {
    
    static let storyboardId = "FavoriteRestaurantListViewController"

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private Properties
    private let viewModel = FavoriteRestaurantListViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var favoriteRestaurants = [Restaurant]()
    
    // MARK: - Fileprivate Properties
    fileprivate let cellHeight: CGFloat = 130
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    // MARK: - Private Methods
    private func configView() {
        tableView.register(UINib(nibName: "FavoriteRestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: FavoriteRestaurantTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.bindFavoriteRestaurants
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] favoRestaurants in
                let restaurants: [Restaurant] = favoRestaurants.map({ favoRestaurant -> Restaurant in
                    return favoRestaurant.toRestaurant()
                })
                self?.favoriteRestaurants = restaurants
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }

}

// MARK: - UITableViewDataSource
extension FavoriteRestaurantListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteRestaurantTableViewCell.reuseIdentifier) as! FavoriteRestaurantTableViewCell
        cell.setRestaurant(favoriteRestaurants[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteRestaurantListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < favoriteRestaurants.count else {
            return
        }
        let storyboard = UIStoryboard(name: FavoriteRestaurantMapViewController.storyboardId,
                                      bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController()
            as? FavoriteRestaurantMapViewController else {
                return
        }
        vc.setFavoriteRestaurant(favoriteRestaurants[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
