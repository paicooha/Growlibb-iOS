//
//  UIButton+.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/14.
//

import UIKit

extension UIButton {
    func setRadius() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 9
    }
}
