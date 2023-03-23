//
//  LoaderView.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

public class XLoaderView: UIView {

    private lazy var loadingView: UILabel = {
        let label = XLabel(
            text: "Loading...",
            typography: .bodyMedium)
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        updateView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        updateView()
    }

    public convenience init() {
        self.init(frame: CGRect.zero)

        setup()
    }

    public func show() {
        isHidden = false
    }

    public func hide() {
        isHidden = true
    }
}

private extension XLoaderView {
    func setup() {
        anchor(width: 120, height: 120)
        addSubview(loadingView)
        loadingView.anchor(width: 100, height: 100)
        loadingView.centerInSuperview()
    }

    func updateView() {
        hide()
    }
}
