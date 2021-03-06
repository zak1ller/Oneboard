//
//  ClipboardListCell.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/19.
//

import Foundation
import UIKit

class ClipboardListCell: UITableViewCell {
    
    lazy var containerView = UIView().then{
        $0.backgroundColor = .subBackground
        $0.layer.cornerRadius = 16
    }
    lazy var dateLabel = UILabel().then{
        $0.textColor = .lightGray
        $0.font = .date
    }
    lazy var contentsLabel = UILabel().then{
        $0.textColor = .darkText
        $0.font = .contents
        $0.numberOfLines = 20
    }
    
    var longClick: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setView()
        setConstraint()
    }
    
    @objc func viewLongPressed() {
        VibrateManager.changeOrSelectVibrate()
        longClick?()
    }
    
    func setView() {
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(contentsLabel)
        containerView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed)))
    }
    
    func setConstraint() {
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
        }
        contentsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(_ clipboard: Clipboard) {
        let date = Date.stringToDate(clipboard.createdDate)
        let dateString = Date.dateToString(date)
        dateLabel.text = dateString
        contentsLabel.text = clipboard.contents
    }
}
