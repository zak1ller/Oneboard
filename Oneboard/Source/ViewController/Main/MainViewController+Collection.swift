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
        
        view.makeToast("CLIPBOARD_COPIED".localized)
    }
    
    func mainListCollectionViewDidLongPressed(i: Int) {
        VibrateManager.changeOrSelectVibrate()
        let item = list[i]
        
        var subject: String {
            if let value = item.subject {
                if value.isEmpty {
                    return "CLIPBOARD_EMPTY_SUBJECT".localized
                } else {
                    return value
                }
            } else {
                return "CLIPBOARD_EMPTY_SUBJECT".localized
            }
        }
        
        let alert = UIAlertController(title: subject, message: nil, preferredStyle: UIAlertController.actionSheetForiPad)
        alert.addAction(UIAlertAction(title: "GENERAL_CANCEL".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "GENERAL_SHARE".localized, style: .default, handler: { _ in
            self.shareCopy(item, i)
        }))
        alert.addAction(UIAlertAction(title: "GENERAL_EDIT".localized, style: .default, handler: { _ in
            self.editCopy(item)
        }))
        alert.addAction(UIAlertAction(title: "GENERAL_DELETE".localized, style: .destructive, handler: { _ in
            self.removeCopy(item)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func shareCopy(_ item: Copy, _ index: Int) {
        var shareObject = [Any]()
        shareObject.append(item.contents ?? "")
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let attributes = collectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 0))
            let cellFrameInSuperview = collectionView.convert(attributes!.frame, to: collectionView.superview)
            activityViewController.popoverPresentationController?.sourceRect = cellFrameInSuperview
        }
            
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.view.makeToast("GENERAL_SENT".localized)
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
