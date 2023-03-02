//
//  UITextField+.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/23.
//

import UIKit

extension UITextField: UITextFieldDelegate {
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }

    func isEmpty() -> Bool {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "").isEmpty
    }
}
