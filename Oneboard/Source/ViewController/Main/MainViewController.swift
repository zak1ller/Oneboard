//
//  ViewController.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/08.
//

import UIKit

class MainViewController: UIViewController {
    var addButton = UIButton(type: .system).then{
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(UIColor.darkText, for: .normal)
        $0.titleLabel?.font = UIFont.textButton
    }
    var searchBar = UISearchBar().then{
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
        return cv
    }()
    
    var list: [Copy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        fetchList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(CopyManager.get())
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.pin.top(view.pin.safeArea.top+16).right(16).sizeToFit()
        addButton.pin.height(48)
        searchBar.pin.top(view.pin.safeArea.top+16).left(16).before(of: addButton).right(16).height(48)
        collectionView.pin.left(16).right(16).below(of: searchBar).marginTop(16).bottom(view.pin.safeArea.bottom)
    }
    
    @objc func pressedAddButton() {
        let vc = AddViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func fetchList() {
        list.removeAll()
        CopyManager.get().forEach({ self.list.append($0) })
        collectionView.reloadData()
    }
    
    func setView() {
        view.backgroundColor = UIColor.background
        view.addSubview(addButton)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        addButton.addTarget(self, action: #selector(pressedAddButton), for: .touchUpInside)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}