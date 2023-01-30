//
//  RetrospectRightView.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/16.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

final class RetrospectRightView: UIView {
    // MARK: Lifecycle

    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var contentView = UIView().then { view in
        view.backgroundColor = .veryLightBlue
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.12
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12 / UIScreen.main.scale
        view.layer.shadowPath = nil
    }
    
    var label = UILabel().then { label in
        label.text = ""
        label.font = .pretendardSemibold12
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .right
    }
}

// MARK: - Layout

extension RetrospectRightView {
    private func setupViews() {
        addSubviews([
            contentView,
            label
        ])

        contentView.addSubviews([
            label,
        ])
    }

    private func initialLayout() {
        contentView.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(210)
            make.height.equalTo(74)
        }

        label.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
}
