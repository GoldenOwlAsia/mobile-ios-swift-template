//
//  Label.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

public class XLabel: UILabel {
    public var typographyType: XTypographyType = .bodyMedium {
        didSet {
            updateAttributedText()
        }
    }

    public init(frame: CGRect = .zero,
                text: String?,
                typography: XTypographyType,
                textColor: UIColor? = XColors.label) {
        super.init(frame: frame)

        self.text = text
        self.typographyType = typography

        if let color = textColor {
            self.textColor = color
        }

        updateAttributedText()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        updateAttributedText()
    }
}

private extension XLabel {
    func updateAttributedText() {
        if let text = text {
            attributedText = XTypography.getAttributedString(
                forString: text,
                typographyType: typographyType,
                textColor: textColor)
        } else {
            attributedText = nil
        }
    }
}
