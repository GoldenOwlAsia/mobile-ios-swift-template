//
//  DemoUIViewController.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

class DemoUIViewController: BaseViewController {

    let primaryButton: XButton = {
        let button = XButton(style: .primary, size: .small,
                             text: "Primary Button")
        button.addTarget(self, action: #selector(doSomeThing), for: .touchUpInside)
        return button
    }()

    let primaryButtonWithIcon: XButton = {
        let button = XButton(style: .primary, size: .small,
                             text: "Primary Button with Icon",
                             icon: UIImage(systemName: "pencil"))
        button.addTarget(self, action: #selector(doSomeThing), for: .touchUpInside)
        return button
    }()

    let primaryButtonDisable: XButton = {
        let button = XButton(style: .primary, size: .small,
                             text: "Primary Button Disable")
        button.isEnabled = false
        return button
    }()

    //
    let secondaryButton: XButton = {
        let button = XButton(style: .secondary, size: .small,
                             text: "Secondary Button")
        button.addTarget(self, action: #selector(doSomeThing), for: .touchUpInside)
        return button
    }()

    let secondaryButtonDisable: XButton = {
        let button = XButton(style: .secondary, size: .small,
                             text: "Secondary Button Disable")
        button.isEnabled = false
        return button
    }()

    ///
    let outlineButton: XButton = {
        let button = XButton(style: .outline, size: .small,
                             text: "Outline Button")
        button.addTarget(self, action: #selector(doSomeThing), for: .touchUpInside)
        return button
    }()

    let outlineButtonDisable: XButton = {
        let button = XButton(style: .outline, size: .small,
                             text: "Outline Button Disable")
        button.isEnabled = false
        return button
    }()
    //
    let textButton: XButton = {
        let button = XButton(style: .text, size: .small,
                             text: "Text Button")
        button.addTarget(self, action: #selector(doSomeThing), for: .touchUpInside)
        return button
    }()

    let textButtonDisable: XButton = {
        let button = XButton(style: .text, size: .small,
                             text: "Text Button Disable")
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setup() {
        // 1
        addBelow(primaryButton, top: view.safeAreaLayoutGuide.topAnchor)
        addBelow(primaryButtonWithIcon, top: primaryButton.bottomAnchor)
        addBelow(primaryButtonDisable, top: primaryButtonWithIcon.bottomAnchor)
        //
        addBelow(secondaryButton, top: primaryButtonDisable.bottomAnchor)
        addBelow(secondaryButtonDisable, top: secondaryButton.bottomAnchor)
        //
        addBelow(outlineButton, top: secondaryButtonDisable.bottomAnchor)
        addBelow(outlineButtonDisable, top: outlineButton.bottomAnchor)
        //
        addBelow(textButton, top: outlineButtonDisable.bottomAnchor)
        addBelow(textButtonDisable, top: textButton.bottomAnchor)

    }
    override func update() {

    }

    @objc func doSomeThing() {
        showToast(title: "Button Clicked", subTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sagittis nunc quis magna congue, id porta velit posuere. Vivamus euismod ex in arcu pellentesque, id dapibus lectus malesuada. Sed auctor ligula eget augue rhoncus, sed tristique sapien tempor. ")
    }
}
