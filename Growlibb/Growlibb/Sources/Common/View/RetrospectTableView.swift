//
//  RetrospectTableView.swift
//  Growlibb
//
//  Created by 이유리 on 2023/07/08.
//

import UIKit

class RetrospectTableView: UITableView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.size != self.intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

}
