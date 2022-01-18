//
//  MainListCollectionView.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/09.
//

import Foundation
import UIKit

protocol MainListCollectionViewCellDelegate: AnyObject {
    func mainListCollectionViewDidLongPressed(i: Int)
    func mainListCollectionViewDidPressed(i: Int)
    func mainListCollectionViewStarButtonPressed(i: Int)
}

class MainListCollectionViewCell: UICollectionViewCell {
    var containerView = UIButton().then({
        $0.backgroundColor = UIColor.subBackground
        $0.layer.cornerRadius = 16
    })
    var starImageView = UIImageView().then{
        $0.image = UIImage(named: "icAllStar")
    }
    var starImageButton = UIButton()
    var subjectLabel = UILabel().then{
        $0.textColor = UIColor.darkText
        $0.font = UIFont.title
    }
    var contentLabel = UILabel().then{
        $0.textColor = UIColor.darkText
        $0.font = UIFont.contents
    }
    
    weak var delegate: MainListCollectionViewCellDelegate?
    var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        containerView.pin.all()
        starImageView.pin.right(16).top(to: containerView.edge.top).marginTop(16).size(16)
        starImageButton.pin.left(to: starImageView.edge.left).right(to: starImageView.edge.right).top(to: starImageView.edge.top).bottom(to: starImageView.edge.bottom).size(32)
        subjectLabel.pin.left(16).right(16).below(of: starImageView).marginTop(8)
        subjectLabel.pin.height(24)
        contentLabel.pin.below(of: subjectLabel).marginTop(8).sizeToFit()
        contentLabel.pin.left(16).right(16)
    }
    
    @objc func longPressed() {
        delegate?.mainListCollectionViewDidLongPressed(i: index)
    }
    
    @objc func pressed() {
        delegate?.mainListCollectionViewDidPressed(i: index)
    }
    
    @objc func starButtonPressed() {
        VibrateManager.changeOrSelectVibrate()
        delegate?.mainListCollectionViewStarButtonPressed(i: index)
    }
    
    func configure(item: Copy) {
        if let subject = item.subject {
            if subject.isEmpty {
                subjectLabel.text = "제목 없음"
            } else {
                subjectLabel.text = subject
            }
        } else {
            subjectLabel.text = "제목 없음"
        }
        
        contentLabel.text = item.contents
        
        if item.isForceColor {
            starImageView.setImageColor(color: .special)
        } else {
            starImageView.setImageColor(color: .buttonSub)
        }
    }
    
    func setView() {
        contentView.addSubview(containerView)
        containerView.addSubview(subjectLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(starImageView)
        containerView.addSubview(starImageButton)
        containerView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressed)))
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressed)))
        starImageButton.addTarget(self, action: #selector(starButtonPressed), for: .touchUpInside)
    }
}
