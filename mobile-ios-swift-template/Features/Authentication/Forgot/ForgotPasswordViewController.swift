//
//  ForgotPasswordViewController.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

class ForgotPassowrdViewController: BaseViewController {

    private lazy var titleLabel = SignTitle(text: "Forgot Password")


    private lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.delegate = self
        textField.text = ""
        textField.borderStyle = .roundedRect
        return textField
    }()

    let nextButton: XButton = {
        let button = XButton(style: .primary, size: .medium,
                             text: "Submit")
        button.addTarget(self, action: #selector(onClickNext), for: .touchUpInside)
        return button
    }()

    override func setup() {
        addBelow(titleLabel,
                 top: view.safeAreaLayoutGuide.topAnchor,
                 paddingTop: 32, paddingBottom: 32, paddingSide: 64)
        addBelow(emailField, top: titleLabel.bottomAnchor, paddingTop: 64)
        addBelow(nextButton, top: emailField.bottomAnchor, paddingTop: 32)
    }


    @objc func onClickNext() {

    }
}

extension ForgotPassowrdViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return true
    }
}
