//
//  Label.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

extension UILabel {
    public var isTextTruncated: Bool {
        guard let text = text, text.count > 0 else {
            return false
        }

        var range = NSRange(location: 0, length: text.count)
        let size = (text as NSString).boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: frame.size.height),
            options: .usesLineFragmentOrigin,
            attributes: attributedText?.attributes(at: 0, effectiveRange: &range), context: nil).size

        return size.width > bounds.size.width
    }
}
