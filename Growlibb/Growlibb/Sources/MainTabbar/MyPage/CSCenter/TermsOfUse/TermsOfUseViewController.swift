//
//  TermsOfUseViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation
import UIKit
import WebKit

class TermsOfUseViewController: BaseViewController {
    
    var configuration: WKWebViewConfiguration

    override init() {
        
        self.configuration = WKWebViewConfiguration()
        super.init()
    }

    let url = "https://google.co.kr"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initialLayout()
        
        let preferences = WKPreferences()
        let wkwebPagePreferences = WKWebpagePreferences()
        
        wkwebPagePreferences.allowsContentJavaScript = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
                
        let contentController = WKUserContentController()
        contentController.add(self, name: "bridge")
                
        configuration.preferences = preferences
        configuration.userContentController = contentController
                
        let components = URLComponents(string: url)!
                
        let request = URLRequest(url: components.url!)
                
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-navBar.frame.height), configuration: configuration)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(request)
                
        webView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.webView.alpha = 1
        }) { _ in
                    
        }

        navBar.leftBtnItem.rx.tap
            .subscribe(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private var navBar = NavBar().then { navBar in
        navBar.rightBtnItem.isHidden = true
        navBar.leftBtnItem.isHidden = false
        navBar.titleLabel.isHidden = false
        navBar.titleLabel.text = L10n.MyPage.Cs.yakgwan
    }
    
    private var webView = WKWebView()
}

// MARK: - Layout

extension TermsOfUseViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            webView
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension TermsOfUseViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("\(navigationAction.request.url?.absoluteString ?? "")" )
        
        decisionHandler(.allow)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}

extension TermsOfUseViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
}

extension TermsOfUseViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
