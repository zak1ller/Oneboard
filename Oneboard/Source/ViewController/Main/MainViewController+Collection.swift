//
//  MainViewController+Collection.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/09.
//

import Foundation
import UIKit
import SnackBar_swift

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainListCollectionViewCell", for: indexPath) as! MainListCollectionViewCell
        cell.configure(item: list[indexPath.row])
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/2)-22, height: 128)
    }
}

extension MainViewController: MainListCollectionViewCellDelegate {
    func mainListCollectionViewStarButtonPressed(i: Int) {
        CopyManager.changeForceColor(of: list[i])
        fetchList()
    }
    
    func mainListCollectionViewDidPressed(i: Int) {
        searchBar.endEditing(true)
        VibrateManager.changeOrSelectVibrate()
        ClipboardManager.saveToClipboard(text: list[i].contents)
        CustomSnackBar.make(in: view, message: "클립보드에 복사되었습니다.", duration: .lengthShort).show()
    }
    
    func mainListCollectionViewDidLongPressed(i: Int) {
        VibrateManager.changeOrSelectVibrate()
        let item = list[i]
        
        var subject: String {
            if let value = item.subject {
                if value.isEmpty {
                    return "제목 없음"
                } else {
                    return value
                }
            } else {
                return "제목 없음"
            }
        }
        
        let alert = UIAlertController(title: subject, message: nil, preferredStyle: UIAlertController.actionSheetForiPad)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "편집", style: .default, handler: { _ in
            self.editCopy(item: item)
        }))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.removeCopy(item: item)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func editCopy(item: Copy) {
        let vc = AddViewController()
        vc.delegate = self
        vc.isEditMode = true
        vc.toEditCopyItem = item
        present(vc, animated: true, completion: nil)
    }
    
    func removeCopy(item: Copy) {
        CopyManager.remove(copy: item)
        fetchList()
    }
}
