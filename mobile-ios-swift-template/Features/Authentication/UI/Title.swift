//
//  Title.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

class SignTitle: XLabel {
    init(text: String?) {
        super.init(text: text, typography: .titleLarge, textColor: XColors.label)
        textAlignment = .center
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
