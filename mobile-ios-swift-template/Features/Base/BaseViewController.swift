//
//  BaseViewController.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = XColors.background
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

extension BaseViewController: XComponent {
    @objc func setup() {
        // Must override by subclass
    }

    @objc func update() {
        // Can override by subclass
    }
}
