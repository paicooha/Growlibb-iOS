//
//  NSMutableAttributedString+.swift
//  Growlibb
//
//  Created by 이유리 on 2023/09/12.
//

import UIKit

extension NSMutableAttributedString {
    func style(attrs: [NSAttributedString.Key: Any], range: NSRange) -> NSMutableAttributedString {
        addAttributes(attrs, range: range)
        return self
    }
    
    func addBlueStringStyleToRange(ranges: [NSRange]) -> NSMutableAttributedString {
        ranges.forEach {
            addAttribute(.foregroundColor, value: UIColor.primaryBlue, range: $0)
        }
        return self
    }
}
