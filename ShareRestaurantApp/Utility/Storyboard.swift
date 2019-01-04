//
//  Storyboard.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/01/04.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     StoryBoardからインスタンスを作成
     
     前提条件
     - StoryBoardの名前がViewControllerと同一になっている
     - StoryBoard内のViewControllerがinitial ViewControllerになっている
     
     呼び出し方
     let vc = ExampleViewController.instanceFromStoryBoard(ExampleViewController.self)
     */
    
    /// Storyboadのファイル名(クラス名)
    static var storyboardName: String {
        return String(describing: self)
    }
    
    class func instanceFromStoryBoard<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        let storyboard = UIStoryboard(name: viewController.storyboardName,
                                      bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? VC else {
            // インスタンスが取れない時は設定ミスのためクラッシュさせる
            fatalError("Couldn't instantiate \(storyboardName)")
        }
        return vc
    }
}
