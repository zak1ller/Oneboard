//
//  MainViewController+Search.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/15.
//

import Foundation
import UIKit

extension MainViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearching = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        isSearching = false
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        list.removeAll()
        guard let searchText = searchBar.text else { return }
        CopyManager.search(toText: searchText).forEach({self.list.append($0)})
        collectionView.reloadData()
    }
}
