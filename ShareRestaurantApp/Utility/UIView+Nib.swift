//
//  UIView+Nib.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/01/04.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import UIKit

extension UIView {
    /**
     Nibファイルからインスタンスを取得する
     
     前提条件
     - 変数の型を指定している(型推論を使っているため)
     - Nibファイルの名前がクラス名と同じである
     
     使い方
     let testField: SuggestInputField = SuggestInputField.instanceFromNib()
     
     */
    class func instanceFromNib<T: UIView>() -> T {
        let className = String(describing: T.self)
        return UINib(nibName: className,
                     bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
    }
    
    /**
     Nibファイルからインスタンスを取得する
     
     前提条件
     - Nibファイルの名前がクラス名と同じである
     - Nibファイルのオーナーを自クラスで設定している
     - Nibファイルの大元のViewはUIViewにしている
     
     使い方
     初期化時に呼び出して追加する
     
     let v = loadFromNib()
     addSubView(v)
     // AutoLayoutなどでView全体と重なるようになる
     
     */
    func loadFromNib() -> UIView {
        let nibName = String(describing: type(of: self))
        return UINib(nibName: nibName,
                     bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    /**
     Nibファイルから読み込んだViewを追加する
     基本はNib側ではこちらを使用し、画面表示を行う
     
     読み込んだViewはselfめいいっぱいに重なるようにaddされる
     */
    func addViewFromNib() {
        let view = loadFromNib()
        // AutoLayoutあり、なしどちらにも対応できるようにautoresizingMaskを指定
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = bounds
        addSubview(view)
    }
}
