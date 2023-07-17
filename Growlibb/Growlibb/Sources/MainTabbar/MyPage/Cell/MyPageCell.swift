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

final class MyPageCell: UITableViewCell {

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup() // cell 세팅
        initialLayout() // cell 레이아웃 설정
    }
    
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
//        self.textView.text = ""
//        self.deleteButton.isHidden = true
    }
    var view = UIView()
    
    var label = UILabel().then { view in
        view.font = .pretendardMedium14
    }
    
    var rightArrow = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }
        view.image = Asset.icArrowRightBlue.image
    }
}

extension MyPageCell {
    private func setup() {

        selectionStyle = .none
        contentView.addSubview(view)
        
        view.addSubviews([
            label,
            rightArrow
        ])
    }

    private func initialLayout() {
        view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(61)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        rightArrow.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.trailing.equalTo(view.snp.trailing).offset(-18)
        }
    }
}

extension MyPageCell {
    static let id: String = "\(MyPageCell.self)"
}

