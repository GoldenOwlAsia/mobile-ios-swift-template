//
//  Image.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

extension UIImage
{
    func resizedImage(Size sizeImage: CGSize) -> UIImage?
    {
        let widthFactor = size.width / sizeImage.width
        let heightFactor = size.height / sizeImage.height
        var resizeFactor = size.height > size.width ? heightFactor : widthFactor

        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size.width / resizeFactor, height: size.height / resizeFactor))
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        self.draw(in: frame)
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.withRenderingMode(.alwaysOriginal)
        return resizedImage
    }
}
