//
//  AddViewController+TextView.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/09.
//

import Foundation
import UIKit

extension AddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            DispatchQueue.main.async {
                textView.text = nil
                textView.textColor = UIColor.darkText
            }
        }
    }
       
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            DispatchQueue.main.async {
                textView.text = self.contentTextViewPlaceHolder
                textView.textColor = UIColor.lightGray
            }
        }
    }
}
