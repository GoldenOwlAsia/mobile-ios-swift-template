//
//  WebViewController.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit
import WebKit

public protocol XWebViewControllerDelegate: AnyObject {
    func webViewControllerDidTapClose(_ webViewController: XWebViewController)
    func webViewControllerDidSucceedToLoadUrl(_ webViewController: XWebViewController, url: URL?)
    func webViewControllerDidFailToLoadUrl(_ webViewController: XWebViewController, url: URL?, error: Error)
}

open class XWebViewController: UIViewController {

    public var url: URL = URL(string: "https://google.com")!
    public var isFooterHidden = false
    public var showShareButton = true

    public weak var delegate: XWebViewControllerDelegate?

    public lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()

    public lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(didTapClose))
        button.tintColor = XColors.label ?? .black
        return button
    }()

    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        return view
    }()

    public lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        button.tintColor = XColors.labelSecondary ?? .gray

        return button
    }()

    public lazy var forwardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        button.tintColor = XColors.labelSecondary ?? .gray

        return button
    }()

    let loadingView = XLoaderView()

    private var footerViewBottomConstraint: NSLayoutConstraint?
    private var scrollPosition = CGPoint.zero
    private var isFooterDoneAdjusting = true
    private let hiddentFooterConstant: CGFloat = 80

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.scrollView.delegate = self

        setupTitle()
        setupBackButton()
        if showShareButton {
            setupShareButton()
        }

        let webViewBottomAnchor: NSLayoutYAxisAnchor
        if isFooterHidden {
            webViewBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        } else {
            setupFooterView()

            webViewBottomAnchor = footerView.topAnchor
        }

        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       leading: view.leadingAnchor,
                       bottom: webViewBottomAnchor,
                       trailing: view.trailingAnchor)

        view.addSubview(loadingView)
        loadingView.centerInSuperview()

        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)

        updateNavigationButtons()
    }

    public func reloadWebView() {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}

extension XWebViewController {
    @objc public func didTapClose() {
        delegate?.webViewControllerDidTapClose(self)

        if let viewControllers = navigationController?.viewControllers, viewControllers.count > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func didTapShare() {

        let itemsToShare = [url]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop,
                                                        UIActivity.ActivityType.saveToCameraRoll,
                                                        UIActivity.ActivityType.openInIBooks]

        present(activityViewController, animated: true, completion: nil)
    }

    @objc func didTapBack() {
        webView.goBack()
    }

    @objc func didTapForward() {
        webView.goForward()
    }

    func updateNavigationButtons() {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }

    func setupTitle() {
        let titleLabel = XLabel(
            text: title ?? url.absoluteString,
            typography: (title != nil) ? .bodyMedium : .bodySmall
        )
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingTail
        if title == nil {
            titleLabel.widthAnchor.constraint(equalToConstant: 133).isActive = true
        }
        navigationItem.titleView = titleLabel
    }

    func setupBackButton() {
        navigationItem.leftBarButtonItem = closeButton
    }

    func setupShareButton() {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "square.add.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(didTapShare))
        button.tintColor = XColors.label ?? .black
        navigationItem.rightBarButtonItem = button
    }

    func setupFooterView() {
        view.addSubview(footerView)
        footerView.anchor(
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: 50)
        footerViewBottomConstraint = footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        footerViewBottomConstraint?.isActive = true

        footerView.addSubview(backButton)
        backButton.anchor(
            left: footerView.leftAnchor,
            paddingLeft: 20,
            width: 30)
        backButton.centerYToSuperview()

        footerView.addSubview(forwardButton)
        forwardButton.anchor(
            left: backButton.rightAnchor,
            paddingLeft: 25,
            width: 30)
        forwardButton.centerYToSuperview()
    }

    func hideFooter() {
        guard isFooterDoneAdjusting, !webView.isLoading, let constraintConstant = footerViewBottomConstraint?.constant, constraintConstant == 0 else { return }

        isFooterDoneAdjusting = false
        UIView.animate(withDuration: 1) {
            self.footerViewBottomConstraint?.isActive = false
            self.footerViewBottomConstraint = self.footerView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: self.hiddentFooterConstant)
            self.footerViewBottomConstraint?.isActive = true
        } completion: { _ in
            self.isFooterDoneAdjusting = true
        }
    }

    func showFooter() {
        guard isFooterDoneAdjusting, !webView.isLoading, let constraintConstant = footerViewBottomConstraint?.constant, constraintConstant > 0 else { return }

        isFooterDoneAdjusting = false
        UIView.animate(withDuration: 1) {
            self.footerViewBottomConstraint?.isActive = false
            self.footerViewBottomConstraint = self.footerView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            self.footerViewBottomConstraint?.isActive = true
        } completion: { _ in
            self.isFooterDoneAdjusting = true
        }
    }
}

extension XWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingView.show()
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.hide()
        updateNavigationButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showFooter()
        }

        delegate?.webViewControllerDidSucceedToLoadUrl(self, url: webView.url)
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingView.hide()
        updateNavigationButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showFooter()
        }

        delegate?.webViewControllerDidFailToLoadUrl(self, url: webView.url, error: error)
    }
}

extension XWebViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollPosition = scrollView.contentOffset
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPosition = scrollView.contentOffset
        let previousPosition = scrollPosition
        let isScrollUpward = (currentPosition.y - previousPosition.y) > 0

        if isScrollUpward {
            hideFooter()
        } else {
            showFooter()
        }
    }
}
