//
//  AppContext.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import Toast_Swift
import UIKit

class AppContext {
    static let shared = AppContext()
    private init() {}

    var rootNavigationController: UINavigationController?

    var safeAreaInsets: UIEdgeInsets = .zero
    let tabHeight: CGFloat = 54
    let navHeight: CGFloat = 48

    func makeToast(_ message: String?) {
        if let message = message, !message.isEmpty {
            rootNavigationController?.view.hideAllToasts()
            rootNavigationController?.view.makeToast(message)
        }
    }

    func makeToastActivity(position: ToastPosition) {
        rootNavigationController?.view.hideToastActivity()
        rootNavigationController?.view.makeToastActivity(position)
    }

    func hideToastActivity() {
        rootNavigationController?.view.hideToastActivity()
    }
}
