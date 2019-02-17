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
    
    private let viewModel = FavoriteRestaurantListViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var favoriteRestaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        tableView.register(UINib(nibName: "FavoriteRestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: FavoriteRestaurantTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        
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
