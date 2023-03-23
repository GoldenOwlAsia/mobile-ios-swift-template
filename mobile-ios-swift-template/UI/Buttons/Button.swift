//
//  Buttons.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

public class XButton: UIButton {
    //MARK: - Properties

    let cornerRadius = 4.0
    var buttonText: String
    var buttonStyle: XButtonStyle

    var loadingView: UIView?

    public var leftIcon: UIImage? {
        didSet {
            addLeftIcon()
        }
    }

    var buttonSize: XButtonSize

    override public var isEnabled: Bool {
        didSet {
            setColorForState(isEnabled: isEnabled)
        }
    }

    override open var isHighlighted: Bool {
        didSet {
            setColorForTap(isTapped: isHighlighted)
        }
    }


    open var changeTitle: String = "" {
        didSet {
            updateTitle(changeTitle)
        }
    }

    //MARK: - Life Cycle
    public init(style: XButtonStyle, size: XButtonSize, text: String,
                icon: UIImage? = nil) {
        self.buttonText = text
        self.buttonStyle = style
        self.leftIcon = icon
        self.buttonSize = size
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Helper Functions
    private func configureUI() {
        let attributedTitle = buttonSize.getTitleString (
            for: buttonText
        )
        setAttributedTitle(attributedTitle, for: .normal)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        contentHorizontalAlignment = .center

        //Button height
        heightAnchor.constraint(
            equalToConstant: buttonSize.getButtonHeight()
        ).isActive = true

        //Title Padding
        titleEdgeInsets = buttonSize.getPadding()

        if (leftIcon != nil) { addLeftIcon() }
        setDefaultConfig()
    }

    private func addLoadingButton() {
        loadingView = UIView()
        addSubview(loadingView ?? UIView())
        let loadingSize = buttonSize.getLoadingDimension()
        loadingView?.anchor(width: loadingSize.width, height: loadingSize.height)
        loadingView?.centerInSuperview()
        contentHorizontalAlignment = .center
    }

    private func updateTitle(_ title: String) {
        let title = buttonSize.getTitleString (for: title)
        setAttributedTitle(title, for: .normal)
    }

    private func addLeftIcon() {
        let iconSize = buttonSize.getIconDimension()
        let leftImage = leftIcon?.resizedImage(Size: CGSize(width: iconSize.width, height: iconSize.height))
        setImage(leftImage, for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        contentMode = .scaleAspectFit
    }

    private func removeLeftIcon() {
        setImage(nil, for: .normal)
    }

    private func setDefaultConfig() {
        switch buttonStyle {
        case .primary:
            backgroundColor = XColors.accent
            titleLabel?.textColor = XColors.label
        case .secondary:
            backgroundColor = XColors.buttonSecondary
            titleLabel?.textColor = XColors.label
        case .text:
            backgroundColor = .clear
            titleLabel?.textColor = XColors.label
        case .outline:
            backgroundColor = .clear
            layer.borderColor = XColors.accent?.cgColor
            layer.borderWidth = 1
            titleLabel?.textColor = XColors.label
        }
    }
}

//MARK: - handle button state
private extension XButton {
    func setColorForState(isEnabled: Bool) {
        switch buttonStyle {
        case .primary:
            if isEnabled {
                backgroundColor = XColors.accent
                titleLabel?.textColor = XColors.label
            } else {
                backgroundColor = XColors.disable
                titleLabel?.textColor = XColors.labelSecondary
            }
        case .secondary:
            if isEnabled {
                backgroundColor = XColors.buttonSecondary
                titleLabel?.textColor = XColors.label
            } else {
                backgroundColor = XColors.disable
                titleLabel?.textColor = XColors.labelSecondary
            }
        case .text:
            if isEnabled {
                backgroundColor = .clear
                titleLabel?.textColor = XColors.label
            } else {
                backgroundColor = .clear
                titleLabel?.textColor = XColors.labelSecondary
            }
        case .outline:
            if isEnabled {
                backgroundColor = .clear
                layer.borderColor = XColors.accent?.cgColor
                layer.borderWidth = 1
                titleLabel?.textColor = XColors.label
            } else {
                backgroundColor = .clear
                layer.borderColor = XColors.disable?.cgColor
                layer.borderWidth = 1
                titleLabel?.textColor = XColors.labelSecondary
            }
        }
    }

    //
    func setColorForTap(isTapped: Bool) {
        switch buttonStyle {
        case .primary:
            backgroundColor = isTapped ? .gray : XColors.accent
        case .secondary:
            backgroundColor = isTapped ? .gray : XColors.buttonSecondary
        case .text:
            backgroundColor = isTapped ? .gray : .clear
        case .outline:
            backgroundColor = isTapped ? .gray : .clear
        }
    }
}
