//
//  MainViewController+AddView.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/09.
//

import Foundation
import UIKit

extension MainViewController: AddViewControllerDelegate {
    func addViewControllerDidSave(isEditingMode: Bool) {
        fetchList()
    }
}
