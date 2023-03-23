//
//  SignupViewController.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

class SignupViewController: BaseViewController {

    private lazy var titleLabel = SignTitle(text: "Sign up")

    private lazy var nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "User name"
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.text = ""
        textField.borderStyle = .roundedRect
        return textField
    }()

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

    private lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.text = ""
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()

    let nextButton: XButton = {
        let button = XButton(style: .primary, size: .medium,
                             text: "Sign up")
        button.addTarget(self, action: #selector(onClickNext), for: .touchUpInside)
        return button
    }()

    let gotoLoginButton: XButton = {
        let button = XButton(style: .text, size: .small,
                             text: "Already have an account? Login")
        button.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        return button
    }()

    override func setup() {
        addBelow(titleLabel, top: view.safeAreaLayoutGuide.topAnchor,
                 paddingTop: 32, paddingBottom: 32, paddingSide: 64)
        addBelow(nameField, top: titleLabel.bottomAnchor, paddingTop: 64)
        addBelow(emailField, top: nameField.bottomAnchor)
        addBelow(passwordField, top: emailField.bottomAnchor)
        addBelow(nextButton, top: passwordField.bottomAnchor, paddingTop: 32)
        addBelow(gotoLoginButton, top: nextButton.bottomAnchor)
    }

    @objc func onClickNext() {

    }
    @objc func backToLogin() {
        navigationController?.popViewController(animated: true)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
