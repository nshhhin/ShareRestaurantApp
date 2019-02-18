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

@IBDesignable class StarsView: UIView {
    
    @IBOutlet var starsButton: [UIButton]!
    @IBOutlet weak var stackView: UIStackView!
    
    private let selectStarColor = UIColor(red: 237, green: 185, blue: 24, alpha: 1.0)
    
    private let unselectStarColor = UIColor(red: 66, green: 66, blue: 66, alpha: 1.0)
    
    private let disposeBag = DisposeBag()
    
    private let defaultStarButtonSize: CGFloat = 30.0
    
    private let defaultStackViewSpacing: CGFloat = 12.0
    
    var lastSelectedTag: Int? = nil
    
    @IBInspectable var starButtonSize: CGFloat = 30.0 {
        didSet (newValue) {
            for starButton in starsButton {
                starButton.titleLabel?.font = UIFont.systemFont(ofSize: newValue)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }
    
    func setSelectedStars(_ tagNum: Int?) {
        guard let tagNum = tagNum else {
            lastSelectedTag = nil
            return
        }
        setSelectStarsLayout(tagNum)
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
        guard let lastSelectTag = lastSelectedTag else {
            setSelectStarsLayout(selectButton.tag)
            return
        }
        
        guard lastSelectTag != selectButton.tag else {
            // 前回と同じボタンをタップ
            resetStars()
            return
        }
        
        switch lastSelectTag < selectButton.tag {
        case true:
            setSelectStarsLayout(selectButton.tag)
        case false:
            resetStarsAfter(tag: selectButton.tag)
        }
        
    }
    /// 指定されたTag(= index)までを選択状態にする
    private func setSelectStarsLayout(_ tag: Int) {
        lastSelectedTag = tag
        for index in 0 ... tag {
            starsButton[index].isSelected = true
        }
    }
    /// 全てを未選択状態にする
    private func resetStars() {
        lastSelectedTag = nil
        for button in starsButton {
            button.isSelected = false
        }
    }
    /// 指定されたTag(= index)以降を未選択状態にする
    private func resetStarsAfter(tag: Int) {
        lastSelectedTag = tag
        let selectNextTag = tag + 1
        for index in selectNextTag ..< starsButton.count {
            starsButton[index].isSelected = false
        }
    }
    
}
