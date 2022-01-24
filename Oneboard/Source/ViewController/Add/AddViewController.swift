//
//  AddViewController.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/09.
//

import Foundation
import UIKit

protocol AddViewControllerDelegate: AnyObject {
    func addViewControllerDidSave(isEditingMode: Bool)
}

class AddViewController: UIViewController {
    var containerView = UIView()
    var topTitleLabel = UILabel().then{
        $0.textColor = UIColor.darkText
        $0.textAlignment = .center
        $0.font = UIFont.topTitle
    }
    var saveButton = UIButton(type: .system).then{
        $0.setTitle("GENERAL_SAVE".localized, for: .normal)
        $0.setTitleColor(UIColor.darkText, for: .normal)
        $0.titleLabel?.font = UIFont.textButton
    }
    var closeButton = UIButton(type: .system).then{
        $0.setTitle("GENERAL_CLOSE".localized, for: .normal)
        $0.setTitleColor(UIColor.darkText, for: .normal)
        $0.titleLabel?.font = UIFont.textButton
    }
    var subjectTextField = UITextField().then{
        $0.textColor = UIColor.darkText
        $0.tintColor = UIColor.darkText
        $0.font = UIFont.contents
        $0.placeholder = "CLIPBOARD_SUBJECT".localized
    }
    var subjectDivider = UIView().then{
        $0.backgroundColor = UIColor.divider
    }
    var contentTextView = UITextView().then{
        $0.tintColor = UIColor.darkText
        $0.font = UIFont.contents
        $0.textContainerInset = UIEdgeInsets.zero
        $0.textContainer.lineFragmentPadding = 0
        $0.backgroundColor = .clear
    }
    
    weak var delegate: AddViewControllerDelegate?
    private var keyboardHeight: CGFloat = 0
    let contentTextViewPlaceHolder = "CLIPBOARD_CONTENTS".localized
    var isEditMode = false
    var toEditCopyItem: Copy?
    
    deinit {
        print("AddViewController Deinited.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setMode()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIWindow.keyboardWillShowNotification,
            object: nil)
                
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIWindow.keyboardWillHideNotification,
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isEditMode {
            subjectTextField.becomeFirstResponder()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topTitleLabel.pin.top(view.pin.safeArea.top+16).hCenter().sizeToFit()
        topTitleLabel.pin.height(48)
        saveButton.pin.top(view.pin.safeArea.top+16).right(16).sizeToFit()
        saveButton.pin.height(48)
        closeButton.pin.top(view.pin.safeArea.top+16).left(16).sizeToFit()
        closeButton.pin.height(48)
        containerView.pin.left().right().below(of: topTitleLabel).bottom(keyboardHeight)
        subjectTextField.pin.top(to: containerView.edge.top).marginTop(40).left(16).right(16)
        subjectTextField.pin.height(24)
        subjectDivider.pin.left(16).right(16).below(of: subjectTextField).marginTop(16).height(1)
        contentTextView.pin.left(16).right(16).below(of: subjectDivider).marginTop(16).bottom(to: containerView.edge.bottom).marginBottom(16)
    }
    
    @objc func keyboardWillShow(_ notificaiton: Notification) {
        if let keyboardFrame: NSValue = notificaiton.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.keyboardHeight = keyboardHeight
        }
        view.setNeedsLayout()
    }
        
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0
        view.setNeedsLayout()
    }

    @objc func pressedSaveButton() {
        if isEditMode {
            edit()
        } else {
            register()
        }
    }
    
    @objc func pressedCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func setMode() {
        if isEditMode {
            topTitleLabel.text = "GENERAL_EDIT".localized
            subjectTextField.text = toEditCopyItem?.subject
            contentTextView.text = toEditCopyItem?.contents
            contentTextView.textColor = UIColor.darkText
        } else {
            topTitleLabel.text = "CLIPBOARD_NEW_ADD".localized
            contentTextView.text = contentTextViewPlaceHolder
            contentTextView.textColor = UIColor.lightGray
        }
    }
    
    func makeContent() -> String {
        if contentTextView.textColor == UIColor.lightGray {
            return ""
        } else {
            return contentTextView.text ?? ""
        }
    }
    
    func register() {
        let subject = subjectTextField.text
        let content = makeContent()
        
        if let error = CopyManager.append(subject: subject, contents: content) {
            let alert = UIAlertController(title: Copy.getErrorMessage(error), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "GENERAL_COMFIRM".localized, style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: {
                self.delegate?.addViewControllerDidSave(isEditingMode: self.isEditMode)
            })
        }
    }
    
    func edit() {
        guard let copy = toEditCopyItem else { return }
        let subject = subjectTextField.text
        let content = makeContent()
        
        if let error = CopyManager.edit(from: copy, newSubject: subject, newContents: content) {
            let alert = UIAlertController(title: Copy.getErrorMessage(error), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "GENERAL_COMFIRM".localized, style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: {
                self.delegate?.addViewControllerDidSave(isEditingMode: self.isEditMode)
            })
        }
    }
    
    func setView() {
        view.backgroundColor = UIColor.background
        view.addSubview(topTitleLabel)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
        view.addSubview(containerView)
        view.addSubview(subjectTextField)
        view.addSubview(subjectDivider)
        view.addSubview(contentTextView)
        saveButton.addTarget(self, action: #selector(pressedSaveButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(pressedCloseButton), for: .touchUpInside)
        contentTextView.delegate = self
    }
}
