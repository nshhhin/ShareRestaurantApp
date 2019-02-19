//
//  StarsView.swift
//  ShareRestaurantApp
//
//  Created by nancy on 2019/02/15.
//  Copyright © 2019年 WataruNakanishi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StarsView: UIView {
    
    @IBOutlet var starsButton: [UIButton]!
    @IBOutlet weak var stackView: UIStackView!
    
    private let selectStarColor = UIColor(red: 237, green: 185, blue: 24, alpha: 1.0)
    
    private let unselectStarColor = UIColor(red: 66, green: 66, blue: 66, alpha: 1.0)
    
    private let disposeBag = DisposeBag()
    
    private let notSelectedNum: Int = 0
    
    private let firstStarsButtonTagNum: Int = 1
    
    var lastSelectedTag: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }
    
    func setSelectedStars(_ tagNum: Int) {
        setSelectStarsLayout(tagNum)
    }
    
    func setStarSize(_ size: CGFloat = 30.0) {
        for starButton in starsButton {
            starButton.titleLabel?.font = UIFont.systemFont(ofSize: size)
        }
    }
    
    private func configView() {
        let view = Bundle.main.loadNibNamed("StarsView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
        
        for starButton in starsButton {
            starButton.rx.controlEvent(.touchUpInside)
                .subscribe({ [weak self] _ in
                    self?.selectedStars(starButton)
                }).disposed(by: disposeBag)
        }
    }
    
    private func selectedStars(_ selectButton: UIButton) {
        guard lastSelectedTag != notSelectedNum else {
            setSelectStarsLayout(selectButton.tag)
            return
        }
        
        guard lastSelectedTag != selectButton.tag else {
            // 前回と同じボタンをタップ
            resetStars()
            return
        }
        
        switch lastSelectedTag < selectButton.tag {
        case true:
            setSelectStarsLayout(selectButton.tag)
        case false:
            resetStarsAfter(tag: selectButton.tag)
        }
        
    }
    /// 指定されたTag(= index)までを選択状態にする
    private func setSelectStarsLayout(_ tag: Int) {
        lastSelectedTag = tag
        guard tag != notSelectedNum else {
            return
        }
        for buttonTag in firstStarsButtonTagNum ... tag {
            let index = buttonTag - 1
            starsButton[index].isSelected = true
        }
    }
    /// 全てを未選択状態にする
    private func resetStars() {
        lastSelectedTag = notSelectedNum
        for button in starsButton {
            button.isSelected = false
        }
    }
    /// 指定されたTag(= index)以降を未選択状態にする
    private func resetStarsAfter(tag: Int) {
        for index in tag ..< starsButton.count {
            starsButton[index].isSelected = false
        }
    }
    
}
