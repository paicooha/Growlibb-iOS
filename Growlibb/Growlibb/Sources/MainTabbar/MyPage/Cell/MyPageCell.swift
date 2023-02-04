//
//  MyPageCell.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation
import UIKit
import RxSwift
import Then
import SnapKit

class MyPageCell: UITableViewCell {

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup() // cell 세팅
        initialLayout() // cell 레이아웃 설정
        
        self.selectionStyle = .none
    }
    
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
//        self.textView.text = ""
//        self.deleteButton.isHidden = true
    }
    
    var label = UILabel().then { view in
        view.font = .pretendardMedium14
    }
    
    var rightArrowButton = UIButton().then { view in
        view.setImage(Asset.icArrowRightBlue.image, for: .normal)
    }
}

extension MyPageCell {
    private func setup() {

        contentView.addSubviews([
            label,
            rightArrowButton
        ])
    }

    private func initialLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(61)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        rightArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-18)
            make.width.height.equalTo(17)
        }
    }
}

extension MyPageCell {
    static let id: String = "\(MyPageCell.self)"
}

