//
//  ViewController.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/08.
//

import UIKit
import CloudKit

class MainViewController: UIViewController {
    
    let addButton = UIButton().then{
        $0.setTitle("GENERAL_ADD".localized, for: .normal)
        $0.setTitleColor(UIColor.darkText, for: .normal)
        $0.titleLabel?.font = UIFont.textButton
    }
    let searchBar = UISearchBar().then{
        $0.tintColor = UIColor.darkText
        $0.searchBarStyle = .minimal
    }
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MainListCollectionViewCell.self, forCellWithReuseIdentifier: "MainListCollectionViewCell")
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    let placeHolderLabel = UILabel().then{
        $0.text = "CLIPBOARD_EMPTY_LIST_MESSAGE".localized
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.font = .contents
        $0.numberOfLines = 0
    }
    
    var list: [Copy] = []
    
    var isSearching = false {
        didSet {
            if isSearching {
                addButton.setTitle("GENERAL_CLOSE".localized, for: .normal)
                clearList()
            } else {
                addButton.setTitle("GENERAL_ADD".localized, for: .normal)
                fetchList()
            }
        }
    }
    
    var isEmptyList = true {
        didSet {
            if isEmptyList {
                placeHolderLabel.isHidden = false
            } else {
                placeHolderLabel.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraint()
        fetchList()
      
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
            self.fetchList()
        })
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.pin.left(16).right(16).below(of: searchBar).marginTop(16).bottom(view.pin.safeArea.bottom)
        placeHolderLabel.pin.left(16).right(16).vCenter().height(200)
    }
    
    @objc func pressedAddButton() {
        if isSearching {
            searchBar.text = nil
            searchBar.endEditing(true)
        } else {
            let vc = AddViewController()
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func pressedCollectionView() {
        searchBar.endEditing(true)
    }
    
    func clearList() {
        list.removeAll()
        collectionView.reloadData()
    }
    
    @objc func fetchList() {
        list.removeAll()
        CopyManager.get().forEach({ self.list.append($0) })
        collectionView.reloadData()
        
        // 일반 목록에서 목록의 아이템 개수가 0인 경우 Place holder를 배치함
        isEmptyList = false
        if !isSearching {
            if list.isEmpty {
                isEmptyList = true
            }
        }
    }
    
    func setView() {
        view.backgroundColor = UIColor.background
        view.addSubview(addButton)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(placeHolderLabel)
        
        searchBar.delegate = self
        addButton.addTarget(self, action: #selector(pressedAddButton), for: .touchUpInside)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedCollectionView)))
    }
    
    func setConstraint() {
        addButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(self.addButton.snp.leading).offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
    }
}
