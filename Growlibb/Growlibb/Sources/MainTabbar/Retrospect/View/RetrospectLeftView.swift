//
//  RetrospectLeftView.swift
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

final class RetrospectLeftView: UIView {
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
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
        /// shadow가 있으려면 layer.borderWidth 값이 필요
        view.layer.borderWidth = 1
        /// 테두리 밖으로 contents가 있을 때, 마스킹(true)하여 표출안되게 할것인지 마스킹을 off(false)하여 보일것인지 설정
        view.layer.masksToBounds = false
        /// shadow 색상
        view.layer.shadowColor = UIColor.black.cgColor
        /// 현재 shadow는 view의 layer 테두리와 동일한 위치로 있는 상태이므로 offset을 통해 그림자를 이동시켜야 표출
        view.layer.shadowOffset = CGSize(width: 0, height: 20)
        /// shadow의 투명도 (0 ~ 1)
        view.layer.shadowOpacity = 0.8
        /// shadow의 corner radius
        view.layer.shadowRadius = 12
    }
    
    var label = UILabel().then { label in
        label.text = ""
        label.font = .pretendardSemibold12
        label.textColor = .primaryBlue
    }
}

// MARK: - Layout

extension RetrospectLeftView {
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
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(74)
        }

        label.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
}
