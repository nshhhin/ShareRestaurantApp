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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach({ indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }
    
    // MARK: - Private Methods
    private func configView() {
        tableView.register(UINib(nibName: "FavoriteRestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: FavoriteRestaurantTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        let mapButton = UIBarButtonItem(title: "地図",
                                        style: .done,
                                        target: self,
                                        action: nil)
        navigationItem.setRightBarButton(mapButton, animated: false)
        
        mapButton.rx.tap
            .subscribe({ [weak self] _ in
                guard let restaurants = self?.favoriteRestaurants else {
                    return
                }
                self?.transitionMapView(restaurants: restaurants)
        }).disposed(by: disposeBag)
        
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
    
    fileprivate func transitionMapView(restaurants: [Restaurant]) {
        let storyboard = UIStoryboard(name: FavoriteRestaurantMapViewController.storyboardId, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? FavoriteRestaurantMapViewController else {
            return
        }
        vc.setFavoriteRestaurant(restaurants)
        navigationController?.pushViewController(vc, animated: true)
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
        transitionMapView(restaurants: [favoriteRestaurants[indexPath.row]])
    }
}
