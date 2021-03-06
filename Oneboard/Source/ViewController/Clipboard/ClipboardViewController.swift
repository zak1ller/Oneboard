//
//  ClipboardViewController.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/18.
//

import Foundation
import UIKit

class ClipboardViewController: UIViewController {
    
    lazy var removeButton = UIButton(type: .system).then{
        $0.setTitle("GENERAL_CLEAR".localized, for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = .textButton
        $0.layer.cornerRadius = 8
    }
    
    lazy var tableView = UITableView().then{
        $0.register(ClipboardListCell.self, forCellReuseIdentifier: "ClipboardListCell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
    }
    
    var clipboards: [Clipboard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConsraint()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        ClipboardManager.append()
        fetchClipboards()
    }
    
    @objc func removeAllButtonPressed() {
        let alert = UIAlertController(title: "CLIPBOARD_CLEAR_MESSAGE".localized, message: nil, preferredStyle: UIAlertController.actionSheetForiPad)
        alert.addAction(UIAlertAction(title: "GENERAL_CANCEL".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "GENERAL_DELETE".localized, style: .destructive, handler: { _ in
            ClipboardManager.removeAll()
            self.fetchClipboards()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func fetchClipboards() {
        clipboards.removeAll()
        
        ClipboardManager.getList().forEach{
            self.clipboards.append($0)
        }
        tableView.reloadData()
    }
    
    func setView() {
        view.backgroundColor = .background
        view.addSubview(removeButton)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        removeButton.addTarget(self, action: #selector(removeAllButtonPressed), for: .touchUpInside)
    }
    
    func setConsraint() {
        removeButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(48)
            make.trailing.equalToSuperview().offset(-48)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(removeButton.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
