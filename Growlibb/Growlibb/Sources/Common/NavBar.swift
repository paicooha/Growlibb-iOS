//
//  NavBar.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/08.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

final class NavBar: UIView {
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

    var titleSpacing: CGFloat = 17 {
        didSet {
            titleLabel.snp.updateConstraints { make in
                make.centerX.equalTo(navContentView.snp.centerX)
                make.bottom.equalTo(navContentView.snp.bottom).offset(-titleSpacing)
            }
        }
    }

    // MARK: Internal

    var topNotchView = UIView()
    var navContentView = UIView()
    var leftBtnItem = UIButton().then { make in
        make.setImage(Asset.icArrowLeft.image, for: .normal)
        make.isHidden = true
    }
    var rightBtnItem = UIButton().then { make in
        make.setImage(Asset.icMypageSetting.image, for: .normal)
        make.isHidden = true
    }
    var titleLabel = UILabel().then { label in
        label.text = ""
        label.font = .pretendardSemibold16
    }
}

// MARK: - Layout

extension NavBar {
    private func setupViews() {
        addSubviews([
            topNotchView,
            navContentView,
        ])

        navContentView.addSubviews([
            leftBtnItem,
            rightBtnItem,
            titleLabel,
        ])
    }

    private func initialLayout() {
        topNotchView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top).offset(11)
            make.height.equalTo(AppContext.shared.safeAreaInsets.top)
        }

        navContentView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(topNotchView.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(AppContext.shared.navHeight)
        }

        leftBtnItem.snp.makeConstraints { make in
            make.leading.equalTo(navContentView.snp.leading).offset(16)
            make.centerY.equalTo(navContentView.snp.centerY)
        }

        rightBtnItem.snp.makeConstraints { make in
            make.trailing.equalTo(navContentView.snp.trailing).offset(-24)
            make.width.height.equalTo(24)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(navContentView.snp.centerX)
            make.centerY.equalTo(leftBtnItem.snp.centerY)
        }
    }
}
