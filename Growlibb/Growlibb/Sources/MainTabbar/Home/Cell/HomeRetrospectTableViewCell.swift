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
    
    var backGround = UIView().then { view in
        view.backgroundColor = .veryLightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }

    var label = UILabel().then { label in
        label.font = .pretendardMedium12
        label.textColor = .black
        label.text = "제목"
    }
}

extension HomeRetrospectTableViewCell {
    private func setup() {
        
        contentView.addSubviews([
            backGround,
            label,
        ])
    }

    private func initialLayout() {
        backGround.snp.makeConstraints{ make in
            make.top.equalTo(self.contentView.snp.top)
            make.leading.equalTo(self.contentView.snp.leading)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-8)
        }
        
        label.snp.makeConstraints{ make in
            make.leading.equalTo(backGround.snp.leading).offset(20)
            make.centerY.equalTo(backGround.snp.centerY)
        }
    }
}

extension HomeRetrospectTableViewCell {
    static let id: String = "\(HomeRetrospectTableViewCell.self)"
}
