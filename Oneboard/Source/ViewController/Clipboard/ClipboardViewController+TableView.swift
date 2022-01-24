//
//  ClipboardViewController+TableView.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/19.
//

import Foundation
import UIKit

extension ClipboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clipboards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clipboard = clipboards[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClipboardListCell", for: indexPath) as! ClipboardListCell
        cell.configure(clipboards[indexPath.row])
        
        cell.longClick = { [weak self] in
            let alert = UIAlertController(title: nil, message: clipboard.contents, preferredStyle: UIAlertController.actionSheetForiPad)
            alert.addAction(UIAlertAction(title: "GENERAL_CANCEL".localized, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "GENERAL_SHARE".localized, style: .default, handler: { _ in
                self?.shareClipboard(clipboard, indexPath.row)
            }))
            alert.addAction(UIAlertAction(title: "GENERAL_DELETE".localized, style: .destructive, handler: { _ in
                self?.removeClipboard(clipboard)
            }))
            self?.present(alert, animated: true, completion: nil)
        }
        return cell
    }
    
    func shareClipboard(_ clipboard: Clipboard, _ index: Int) {
        var shareObject = [Any]()
        shareObject.append(clipboard.contents ?? "")
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let rect = self.tableView.rectForRow(at: IndexPath(row: index, section: 0))
            activityViewController.popoverPresentationController?.sourceRect = rect
        }
        
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.view.makeToast("GENERAL_SENT".localized)
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func removeClipboard(_ clipboard: Clipboard) {
        ClipboardManager.remove(clipboard)
        self.fetchClipboards()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        VibrateManager.changeOrSelectVibrate()
        ClipboardManager.saveToClipboard(text: clipboards[indexPath.row].contents)
        view.makeToast("CLIPBOARD_COPIED".localized)
    }
    
}
