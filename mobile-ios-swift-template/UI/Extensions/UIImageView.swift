//
//  ImageView.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    /**
        Automatically resizes image based on scale and given size.
     
        - Parameter url: url of the image
        - Parameter size: the logical size (1x scale) of the image. Basically, the same size as the image view. This will be modified for the appropriate scale.
        - Parameter additionalOptions: Kingfisher image options to add. By default, these options are already added: imageResizeProcessor, scaleFactor, diskCacheExpiration, diskCacheAccessExtendingExpiration
        - Parameter success: handler to call when Kingfisher succeeded with setting the image
        - Parameter failure: handler to call when Kingfisher failed with setting the image
     */
    public func setResizedImage(from url: URL,
                                size: CGSize,
                                placeholder: UIImage? = nil,
                                additionalOptions: KingfisherOptionsInfo? = nil,
                                success: ((UIImage) -> Void)? = nil,
                                failure: ((Error) -> Void)? = nil) -> DownloadTask? {
        
        let scale = UIScreen.main.scale
        let actualSize = CGSize(width: size.width * scale, height: size.height * scale)
        let imageResizeProcessor = DownsamplingImageProcessor(size: actualSize)
        var options: KingfisherOptionsInfo = [.processor(imageResizeProcessor),
                                              .scaleFactor(scale),
                                              .diskCacheExpiration(.days(30)),
                                              .diskCacheAccessExtendingExpiration(.cacheTime)]
        
        if let additionalOptions = additionalOptions {
            options.append(contentsOf: additionalOptions)
        }
        
        return self.kf.setImage(with: url,
                         placeholder: placeholder,
                         options: options) { result in
            switch result {
            case .success(let successResult):
                success?(successResult.image)
            case .failure(let error):
                print("\(#function) error: \(error.localizedDescription)")
                failure?(error)
            }
        }
    }
}
