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
