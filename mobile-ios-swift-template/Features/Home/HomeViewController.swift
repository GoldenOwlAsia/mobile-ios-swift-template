//
//  ViewController.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 22/03/2023.
//

import UIKit

class HomeViewController: BaseViewController {

    private lazy var image: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(named: "chipi-img")
        return image
    }()

    private lazy var titleLabel: XLabel = {
        let label = XLabel(text: "Welcome on", typography: .titleLarge)
        return label
    }()

    private lazy var supTitleLabel: XLabel = {
        let label = XLabel(text: "The iOS app.", typography: .titleMedium)
        return label
    }()

    private lazy var bodyLabel: XLabel = {
        let label = XLabel(text: "Do you want to discover some features? Just click on one of the three buttons at the bottom of the screen.", typography: .bodyMedium)
        label.numberOfLines = 0
        return label
    }()


    let showDemoButton: XButton = {
        let button = XButton(
            style: .primary, size: .small,
            text: "Show Demo UI"
        )
        button.addTarget(self, action: #selector(showDemoUIView), for: .touchUpInside)
        return button
    }()

    let showLoginButton: XButton = {
        let button = XButton(
            style: .primary, size: .small,
            text: "Show Login"
        )
        button.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setup() {
        addBelow(
            image,
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: 32, paddingBottom: 32, paddingSide: 64)
        addBelow(
            titleLabel,
            top: image.bottomAnchor)
        addBelow(
            supTitleLabel,
            top: titleLabel.bottomAnchor)
        addBelow(
            bodyLabel,
            top: supTitleLabel.bottomAnchor)
        // 1
        addBelow(
            showDemoButton,
            top: bodyLabel.bottomAnchor)
        // 2
        addBelow(
            showLoginButton,
            top: showDemoButton.bottomAnchor)
    }



    @objc func showDemoUIView() {
        let viewController = DemoUIViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func showLogin() {
        let viewController = SigninViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIViewController {
    func addBelow(_ of: UIView,
                  top: NSLayoutYAxisAnchor? = nil,
                  paddingTop: CGFloat = 16,
                  paddingBottom: CGFloat = 0,
                  paddingSide: CGFloat = 16
    ) {
        view.addSubview(of)
        of.anchor(
            top: top,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: paddingTop,
            paddingLeft: paddingSide,
            paddingBottom: paddingBottom,
            paddingRight: paddingSide)
    }
}
