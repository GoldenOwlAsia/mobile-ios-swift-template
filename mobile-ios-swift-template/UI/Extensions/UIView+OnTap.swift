//
//  UIView+OnTap.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

@objc class ClosureSleeve: NSObject {
    let closure: () -> Void

    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc func invoke() {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIView: UIGestureRecognizerDelegate {
    /// Allows adding tap detection to any UIView
    /// - Parameter closure: the method to run
    public func addActionOnTap(_ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        let tapGesture = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
        objc_setAssociatedObject(
            self,
            "[\(Int.random(in: 1...Int.max))]",
            sleeve,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}
