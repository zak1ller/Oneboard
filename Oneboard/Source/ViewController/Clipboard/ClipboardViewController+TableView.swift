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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClipboardListCell", for: indexPath) as! ClipboardListCell
        cell.configure(clipboards[indexPath.row])
        return cell
    }
    
    
}
