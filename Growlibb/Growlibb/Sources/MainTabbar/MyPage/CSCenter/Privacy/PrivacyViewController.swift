//
//  PrivacyViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation
import UIKit
import WebKit

class PrivacyViewController: BaseViewController {

    let url = "https://plum-aster-76d.notion.site/69b19922795441cfb18edd49d6f1f265"
    
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
                
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = contentController
                
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
                
        let components = URLComponents(string: url)!
                
        let request = URLRequest(url: components.url!)
                
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(request)
                
        webView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.webView.alpha = 1
        }) { _ in
                    
        }

    }

    private var navBar = NavBar().then { navBar in
        navBar.rightBtnItem.isHidden = false
        navBar.titleLabel.isHidden = false
        navBar.titleLabel.text = L10n.MyPage.Cs.yakgwan
    }
    
    private var webView: WKWebView!/** 웹 뷰 */
}

// MARK: - Layout

extension PrivacyViewController {
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

extension PrivacyViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("\(navigationAction.request.url?.absoluteString ?? "")" )
        
        decisionHandler(.allow)
    }
}

extension PrivacyViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
}

extension PrivacyViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print(message.name)
    }
}
