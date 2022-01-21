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
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                ClipboardManager.remove(clipboard)
                self?.fetchClipboards()
            }))
            self?.present(alert, animated: true, completion: nil)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        VibrateManager.changeOrSelectVibrate()
        ClipboardManager.saveToClipboard(text: clipboards[indexPath.row].contents)
        CustomSnackBar.make(in: view, message: "클립보드에 복사되었습니다.", duration: .lengthShort).show()
    }
    
}
