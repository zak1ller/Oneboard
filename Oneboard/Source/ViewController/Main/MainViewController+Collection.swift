//
//  MainViewController+Collection.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/09.
//

import Foundation
import UIKit
import Toast_Swift

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
        
        view.makeToast("클립보드에 복사 됨")
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
        alert.addAction(UIAlertAction(title: "공유하기", style: .default, handler: { _ in
            self.shareCopy(item)
        }))
        alert.addAction(UIAlertAction(title: "편집", style: .default, handler: { _ in
            self.editCopy(item)
        }))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.removeCopy(item)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func shareCopy(_ item: Copy) {
        var shareObject = [Any]()
        shareObject.append(item.contents ?? "")
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.view.makeToast("전송되었습니다.")
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func editCopy(_ item: Copy) {
        let vc = AddViewController()
        vc.delegate = self
        vc.isEditMode = true
        vc.toEditCopyItem = item
        present(vc, animated: true, completion: nil)
    }
    
    func removeCopy(_ item: Copy) {
        CopyManager.remove(copy: item)
        fetchList()
    }
}
