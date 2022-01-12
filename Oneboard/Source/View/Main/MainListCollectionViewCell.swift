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
    func mainListCollectionVIewDidPressed(i: Int)
}

class MainListCollectionViewCell: UICollectionViewCell {
    var containerView = UIButton().then({
        $0.backgroundColor = UIColor.subBackground
        $0.layer.cornerRadius = 16
    })
    var subjectLabel = UILabel().then{
        $0.textColor = UIColor.darkText
        $0.font = UIFont.textButton
    }
    var contentLabel = UILabel().then{
        $0.textColor = UIColor.darkText
        $0.font = UIFont.contents
        $0.numberOfLines = 1
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
        subjectLabel.pin.left(16).right(16).top(to: containerView.edge.top).marginTop(16)
        subjectLabel.pin.height(24)
        contentLabel.pin.below(of: subjectLabel).marginTop(16).sizeToFit()
        contentLabel.pin.left(16).right(16)
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
    }
    
    @objc func longPressed() {
        delegate?.mainListCollectionViewDidLongPressed(i: index)
    }
    
    @objc func pressed() {
        delegate?.mainListCollectionVIewDidPressed(i: index)
    }
    
    func setView() {
        contentView.addSubview(containerView)
        containerView.addSubview(subjectLabel)
        containerView.addSubview(contentLabel)
        containerView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressed)))
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressed)))
    }
}
