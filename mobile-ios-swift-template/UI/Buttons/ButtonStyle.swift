//
//  ButtonStyle.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

public enum XButtonStyle {
    case primary
    case secondary
    case text
    case outline
}

public enum XButtonSize {
    case large
    case medium
    case small

    func getTitleString(for text: String) -> NSAttributedString {
        switch self {
        case .large:
            return XTypography.getAttributedString (
                forString: text,
                typographyType: .labelLarge
            )
        case .medium:
            return XTypography.getAttributedString (
                forString: text,
                typographyType: .labelMedium
            )
        case .small:
            return XTypography.getAttributedString (
                forString: text,
                typographyType: .labelSmall
            )

        }
    }

    func getIconDimension() -> CGSize {
        switch self {
        case .large:
            return .init(width: 24, height: 24)
        case .medium:
            return .init(width: 16, height: 16)
        case .small:
            return .init(width: 10, height: 10)
        }
    }

    func getLoadingDimension() -> CGSize {
        switch self {
        case .large:
            return .init(width: 40, height: 40)
        case .medium:
            return .init(width: 32, height: 32)
        case .small:
            return .init(width: 24, height: 24)
        }
    }

    func getPadding() -> UIEdgeInsets {
        switch self {
        case .large:
            return UIEdgeInsets.only(top: 12, left: 16, bottom: 12, right: 16)
        case .medium:
            return UIEdgeInsets.only(top: 6, left: 12, bottom: 6, right: 12)
        case .small:
            return UIEdgeInsets.only(top: 4, left: 8, bottom: 4, right: 8)
        }
    }

    func getButtonHeight() -> CGFloat {
        switch self {
        case .large:
            return 48.0
        case .medium:
            return 32.0
        case .small:
            return 24.0
        }
    }
}

