//
//  UIStackView+.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import UIKit

extension UIStackView {
    static func make(
        with subviews: [UIView],
        axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: UIStackView.Alignment = .fill,
        distribution: Distribution = .fill,
        spacing: CGFloat = 0
    ) -> UIStackView {
        let view = UIStackView(arrangedSubviews: subviews)
        view.axis = axis
        view.alignment = alignment
        view.distribution = distribution
        view.spacing = spacing
        return view
    }

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
