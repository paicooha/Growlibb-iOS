//
//  UITableView+.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/19.
//

import UIKit

extension UITableViewCell {
    var tableView: UITableView? {
        var view = superview
        while view != nil && !(view is UITableView) {
            view = view?.superview
        }

        return view as? UITableView
    }
}
