//
//  UITextView+.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/04.
//

import Foundation
import UIKit

extension UITextView {
    func numberOfLine() -> Int {
        
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)
        
        return Int(estimatedSize.height / (self.font!.lineHeight))
    }
}
