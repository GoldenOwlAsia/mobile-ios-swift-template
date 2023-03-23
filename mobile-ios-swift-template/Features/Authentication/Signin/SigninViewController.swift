//
//  SigninViewController.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

class SigninViewController: BaseViewController {

    private lazy var titleLabel = SignTitle(text: "Login")


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
    let forgotButton: XButton = {
        let button = XButton(style: .text, size: .small,
                             text: "Forgot password?")
        button.addTarget(self, action: #selector(onClickForgotPassword), for: .touchUpInside)
        return button
    }()

    let nextButton: XButton = {
        let button = XButton(style: .primary, size: .medium,
                             text: "Login")
        button.addTarget(self, action: #selector(onClickNext), for: .touchUpInside)
        return button
    }()

    let noAccountButton: XButton = {
        let button = XButton(style: .text, size: .small,
                             text: "No have account? Signup now")
        button.addTarget(self, action: #selector(onClickSignup), for: .touchUpInside)
        return button
    }()

    override func setup() {
        addBelow(titleLabel,
                 top: view.safeAreaLayoutGuide.topAnchor,
                 paddingTop: 32, paddingBottom: 32, paddingSide: 64)
        addBelow(emailField,
                 top: titleLabel.bottomAnchor, paddingTop: 64)
        addBelow(passwordField,
                 top: emailField.bottomAnchor)
        addBelow(forgotButton,
                 top: passwordField.bottomAnchor)
        addBelow(nextButton,
                 top: forgotButton.bottomAnchor, paddingTop: 32)
        addBelow(noAccountButton,
                 top: nextButton.bottomAnchor)
    }

    @objc func onClickForgotPassword() {
        let viewController = ForgotPassowrdViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func onClickNext() {

    }
    @objc func onClickSignup() {
        let viewController = SignupViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SigninViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       

        return true
    }
}
