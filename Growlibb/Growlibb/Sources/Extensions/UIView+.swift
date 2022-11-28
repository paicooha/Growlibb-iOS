//
//  UIView+.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/10.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}

extension UIView: UIGestureRecognizerDelegate {
    
    func dismissKeyboardWhenTappedAround() {
        let tap =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.endEditing(false)
    }

    public func gestureRecognizer(_: UIGestureRecognizer, shouldBeRequiredToFailBy _: UIGestureRecognizer) -> Bool {
        return true
    }
}
