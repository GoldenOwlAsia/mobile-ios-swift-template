//
//  Toast.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit


public enum XToastStyle {
    case error
    case notice
    case success
    case normal
}


public class XToast: NSObject {
    var toastTitle = ""
    var toastSubTitle = ""
    var toastStyle: XToastStyle?
    var shouldShowActionIcon: Bool = false

    public init(title: String,
                subTitle: String = "",
                toastStyle: XToastStyle? = .normal,
                shouldShowActionIcon: Bool = false) {
        self.toastTitle = title
        self.toastSubTitle = subTitle
        self.toastStyle = toastStyle ?? .normal
        self.shouldShowActionIcon = shouldShowActionIcon
        self.canHideByTap = true
    }

    public init(title: String) {
        toastTitle = title
    }


    private var hasTitleLink: Bool = false
    private var titleLink: URL?
    private var titleLinkRange: NSRange?
    private var toastHeight: CGFloat = 76
    private var canHideByTap = true
    private var toastView: UIView?
    private var toastHideTimer = 2.0
    private var toastShowDuration = 0.3
    private var toastHideDuration = 0.25
    private var toastReturnDuration = 0.25
    private var topSafeAreaHeight: CGFloat = 44.0
    private lazy var titleLabel = XLabel(
        text: "",
        typography: .bodyMedium
    )

    private var subTitleLabel = XLabel(
        text: "",
        typography: .bodySmall
    )
    private var shouldAutoHide = true

    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    private var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }

    private var topInset: CGFloat {
        if #available(iOS 11.0, *) {
            return toastWindow?.safeAreaInsets.top ?? 44
        } else {
            return 0
        }
    }

    private var toastWindow: UIWindow?
    private var offsetX: CGFloat = 0.0
    private var offsetY: CGFloat = 0.0
    private var offsetAlpha: CGFloat = 0.0
    private var isTouched = false
    private var canRemoveWindow = true

    //TODO: - Handle bottom toast properly

    func show() {
        var windowFrame: UIWindow
        var toastFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if #available(iOS 13.0, *) {
            guard let window = UIApplication.shared.windows.first else { return }
            guard let scene = window.windowScene else { return }
            // safeAreaInsets.top
            topSafeAreaHeight = scene.statusBarManager?.statusBarFrame.height ?? 0
            let topPadding = window.safeAreaInsets.top
            topSafeAreaHeight = topSafeAreaHeight >= topPadding ? topSafeAreaHeight : topPadding
            // toastFrame
            windowFrame = UIWindow(windowScene: scene)
            windowFrame.frame = CGRect(x: 0, y: -100, width: screenWidth, height: toastHeight)

            let horizontalPadding: CGFloat = 24
            toastFrame = CGRect(x: horizontalPadding, y: -100, width: screenWidth - (horizontalPadding * 2), height: toastHeight)

            toastWindow = UIWindow(windowScene: scene)
            toastWindow?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            toastWindow?.windowLevel = UIWindow.Level.statusBar
            toastWindow?.isHidden = false
            toastWindow?.makeKeyAndVisible()
            toastWindow?.windowLevel = (UIWindow.Level.statusBar + 1)
            if toastView == nil {
                toastView = createFloatingToast()
            }
            if let toastView = toastView {
                toastWindow?.addSubview(toastView)
                toastView.translatesAutoresizingMaskIntoConstraints = false
                toastView.anchor(
                    top: toastWindow?.safeAreaLayoutGuide.topAnchor,
                    left: toastWindow?.leftAnchor,
                    paddingLeft: toastFrame.origin.x,
                    width: toastFrame.size.width
                )
                toastView.heightAnchor.constraint(greaterThanOrEqualToConstant: toastHeight).isActive = true

                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                toastView.addGestureRecognizer(tap)
                toastView.isUserInteractionEnabled = true
                animateShow()
                addHideGesture()
            }
        }
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if canHideByTap {
            hideToastView(isManualy: true)
        }
    }

    @objc func handleHideGesture(_ gesture: UIPanGestureRecognizer) {
        guard let toastView = toastView else { return }
        switch (gesture.state) {
        case .ended, .cancelled, .possible:
            isTouched = false
            offsetX = toastView.frame.origin.x
            offsetY = toastView.frame.origin.y
            let translation = gesture.translation(in: toastView)
            switch true {
            case translation.y > toastView.height:
                hideToastView(isManualy: false)
            case translation.y < -(toastView.height / 3):
                hideToastView(isManualy: false)
            default:
                returnView()
            }
            break
        case.changed:
            self.isTouched = true
            let velocity = gesture.velocity(in: toastView)
            let translation = gesture.translation(in: toastView)

            if abs(velocity.y) > abs(velocity.x) && toastView.frame.origin.x == 0 {
                if translation.y <= 0 {
                    toastView.frame.origin.y = translation.y
                    toastView.alpha = 1.00 + ((gesture.translation(in: toastView).y) / 100)
                } else {
                    toastView.frame.origin.y = 0
                }
            }
            break
        case .began:
            self.isTouched = true
        default:
            break
        }
    }

    private func hideToastView(isManualy: Bool) {
        UIView.animate(withDuration: toastHideDuration, delay: 0.0, options: .curveEaseOut, animations: ({
            guard let toastView = self.toastView else { return }
            toastView.y = self.offsetY - self.toastHeight
            toastView.alpha = 0
            self.canRemoveWindow = true

        }), completion: ({ a in
            if self.canRemoveWindow {
                self.removeWindow()
            }
            self.canRemoveWindow = true
        }))
    }

    private func animateShow() {
        UIView.animate(withDuration: toastShowDuration, delay: 0.0, options: .curveEaseOut, animations: ({
            self.toastView?.y = self.topSafeAreaHeight
        }), completion: ({ _ in
            self.startTimer()
        }))
    }

    private func returnView() {
        UIView.animate(withDuration: toastReturnDuration, delay: 0.0, options: .curveEaseOut, animations: ({
            self.toastView?.x = 0
            self.toastView?.y = 0
            self.toastView?.alpha = 1.0
        }), completion: ({ _ in
            self.offsetX = 0
            self.offsetY = 0
            self.startTimer()
        }))
    }

    private func startTimer() {
        runThisAfterDelay(seconds: shouldAutoHide && !self.isTouched ? self.toastHideTimer : Double(INT32_MAX)) { () -> () in
            self.hideToastView(isManualy: true)
        }
    }

    private func removeWindow() {
        toastWindow?.windowLevel = (UIWindow.Level.statusBar - 1)
        toastWindow?.removeFromSuperview()
        toastWindow = nil
        toastView = nil
    }

    private func addHideGesture() {
        let tapSwipeViewGesture = UIPanGestureRecognizer(target: self,
                                                         action: #selector(handleHideGesture(_:)))
        self.toastView?.addGestureRecognizer(tapSwipeViewGesture)
    }

    @objc func closeToast(sender: UIButton) {
        hideToastView(isManualy: true)
    }

    private func createFloatingToast() -> UIView {
        let contentView = UIView()
        let imageContainerView: UIView = UIView()
        contentView.backgroundColor = XColors.toastBackground

        let closeButton: UIButton = UIButton()
        if shouldShowActionIcon {
            shouldAutoHide = false
            contentView.addSubview(closeButton)

            closeButton.addTarget(self,
                                  action: #selector(closeToast(sender:)),
                                  for: .touchUpInside)
            closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            closeButton.anchor(top: contentView.topAnchor,
                               right: contentView.rightAnchor,
                               paddingTop: 20,
                               paddingRight: 20,
                               width: 24,
                               height: 24)

        }
        contentView.addSubview(imageContainerView)
        imageContainerView.anchor(top: contentView.topAnchor,
                                  left: contentView.leftAnchor,
                                  bottom: contentView.bottomAnchor,
                                  width: 8)
        imageContainerView.backgroundColor = getToastColor()

        let titleView: UIView = titleLabel
        setTitleAttributedText()
        titleLabel.textColor = XColors.label
        titleLabel.numberOfLines = 0

        contentView.addSubview(titleView)

        if !toastSubTitle.isEmpty {
            setSubTitleAttributedText()
            subTitleLabel.textColor = XColors.labelSecondary
            titleLabel.textColor = getToastColor()
            setTitleAttributedText()
            subTitleLabel.numberOfLines = 0
            contentView.addSubview(subTitleLabel)

            titleView.anchor(
                top: contentView.topAnchor,
                left: imageContainerView.rightAnchor,
                right: contentView.subviews.contains(closeButton) ? closeButton.leftAnchor : contentView.rightAnchor,
                paddingTop: 16,
                paddingLeft: 24,
                paddingRight: contentView.subviews.contains(closeButton) ? 5 : 16)

            subTitleLabel.anchor(
                top: titleView.bottomAnchor,
                left: imageContainerView.rightAnchor,
                right: contentView.rightAnchor,
                paddingTop: 4,
                paddingLeft: 24,
                paddingRight: 16
            )
            subTitleLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -16).isActive = true

        } else {
            titleView.anchor(
                top: contentView.topAnchor,
                left: imageContainerView.rightAnchor,
                right: contentView.rightAnchor,
                paddingTop: 16,
                paddingLeft: 24,
                paddingRight: 16
            )
            titleView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -16).isActive = true
        }
        toastView?.layer.borderWidth = 1
        toastView?.layer.cornerRadius = 4
        toastView?.layer.borderColor = XColors.border?.cgColor
        toastView?.clipsToBounds = true
        return contentView
    }

    private func setTitleAttributedText() {
        titleLabel.attributedText = XTypography.getAttributedString(
            forString: toastTitle,
            typographyType: .bodyMedium
        )
    }

    private func setSubTitleAttributedText() {
        subTitleLabel.attributedText = XTypography.getAttributedString(
            forString: toastSubTitle,
            typographyType: .bodySmall
        )
    }

    private func getToastColor() -> UIColor {
        switch toastStyle {
        case .error:
            return .red
        case .notice:
            return .yellow
        case .success:
            return .green
        default:
            return XColors.accent ?? .green
        }
    }


    private func runThisAfterDelay(seconds: Double, after: @escaping () -> ()) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time,
                                      execute: after)
    }
}

fileprivate extension UIView {
    var x: CGFloat {
        get {
            return frame.origin.x
        } set {
            frame = CGRect(x: newValue, y: y, width: width, height: height)
        }
    }

    var y: CGFloat {
        get {
            return frame.origin.y
        } set {
            frame = CGRect(x: x, y: newValue, width: width, height: height)
        }
    }

    var width: CGFloat {
        get {
            return frame.size.width
        } set {
            frame = CGRect(x: x, y: y, width: newValue, height: height)
        }
    }

    var height: CGFloat {
        get {
            return frame.size.height
        } set {
            frame = CGRect(x: x, y: y, width: width, height: newValue)
        }
    }
}



public extension UIViewController {
    func showToast(title: String,
                   subTitle: String = "",
                   toastStyle: XToastStyle? = .normal,
                   shouldShowActionIcon: Bool = false) {
        XToast(title: title,
                  subTitle: subTitle,
                  toastStyle: toastStyle,
                  shouldShowActionIcon: shouldShowActionIcon).show()
    }
}
