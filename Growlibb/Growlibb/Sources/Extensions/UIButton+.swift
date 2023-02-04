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
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
      let hitArea = self.bounds.insetBy(dx: -10, dy: -10)
      return hitArea.contains(point)
    }
}
