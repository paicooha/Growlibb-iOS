//
//  UIScreen+.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/08.
//

import UIKit

extension UIScreen {
    /// - Mini, SE: 375.0
    /// - pro: 390.0
    /// - pro max: 428.0
    var isWiderThan375pt: Bool { bounds.size.width > 375 } // SE, 미니인지 판단하는 변수
}
