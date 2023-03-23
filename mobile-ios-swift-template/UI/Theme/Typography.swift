//
//  Styles.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

public class XTypography {

    public class func getAttributedString(forString string: String,
                                          typographyType: XTypographyType,
                                          textColor: UIColor? = nil) -> NSAttributedString {
        let attributes = getAttributes(typographyType: typographyType, textColor: textColor)
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }

    public class func getAttributes(typographyType: XTypographyType,
                                    textColor: UIColor? = nil
    ) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[.font] = getFont(typographyType)

        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }
        return attributes
    }

    //MARK: - Fonts
    class func getFont(_ typographyType: XTypographyType) -> UIFont {
        var font: UIFont
        switch typographyType {
        case .bodySmall:
            font = getFont(size: 12,
                           weight: .regular)
        case .bodyMedium:
            font = getFont(size: 14,
                           weight: .regular)
        case .bodyLarge:
            font = getFont(size: 16,
                           weight: .regular)
        case .labelSmall:
            font = getFont(size: 12,
                           weight: .medium)
        case .labelMedium:
            font = getFont(size: 14,
                           weight: .medium)
        case .labelLarge:
            font = getFont(size: 16,
                           weight: .medium)
        case .titleSmall:
            font = getFont(size: 16,
                           weight: .bold)
        case .titleMedium:
            font = getFont(size: 24,
                           weight: .bold)
        case .titleLarge:
            font = getFont(size: 32,
                           weight: .bold)
        }

        return font
    }


    class func getFont(size: Double, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}

extension UILabel {

    public func setTypography(
        typography: XTypographyType,
        textColor: UIColor? = XColors.label,
        range: NSRange? = nil) {
        if let range = range, let currentText = self.attributedText {
            let mutableAttributedText = NSMutableAttributedString(attributedString: currentText)
            let attributes = XTypography.getAttributes(typographyType: typography, textColor: textColor)
            mutableAttributedText.setAttributes(attributes, range: range)
            attributedText = mutableAttributedText
        } else {
            attributedText = XTypography.getAttributedString(
                forString: text ?? "",
                typographyType: typography,
                textColor: textColor)
        }
    }
}
