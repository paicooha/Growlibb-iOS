//
//  HomeRetrospectTableViewCell.swift
//  Growlibb
//
//  Created by 이유리 on 2022/12/04.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class HomeRetrospectTableViewCell: UITableViewCell {

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup() // cell 세팅
        initialLayout() // cell 레이아웃 설정
    }

    var label = UILabel().then { label in
        label.font = .pretendardMedium12
        label.textColor = .black
        label.text = "제목"
    }
}

extension HomeRetrospectTableViewCell {
    private func setup() {
        backgroundColor = .veryLightGray
        self.clipsToBounds = true
        self.layer.cornerRadius = 12

        contentView.addSubviews([
            label,
        ])
    }

    private func initialLayout() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(57)
        }
        
        label.snp.makeConstraints{ make in
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
}

extension HomeRetrospectTableViewCell {
    static let id: String = "\(HomeRetrospectTableViewCell.self)"
}
