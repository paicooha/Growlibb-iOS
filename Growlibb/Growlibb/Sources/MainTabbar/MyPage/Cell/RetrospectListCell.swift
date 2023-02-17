//
//  ViewRetrospectCell.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/15.
//

import Foundation
import UIKit
import RxSwift
import Then
import SnapKit

class RetrospectListCell: UITableViewCell {
    
    var dateUtil = DateUtil.shared

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
    
        self.prepare()
    }
  
    func prepare(dateString: String? = nil) {
        let date = DateUtil.shared.getDate(from: dateString ?? "", format: .yyyyMddDash)
        self.label.text = dateUtil.formattedString(for: date ?? Date(), format: .yyyyMMddKR)
    }
    
    var view = UIView().then { view in
        view.backgroundColor = .veryLightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }
    
    var label = UILabel().then { view in
        view.font = .pretendardMedium12
    }
    
    var rightArrow = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
        view.image = Asset.icArrowRightBlue.image
    }
}

extension RetrospectListCell {
    private func setup() {

        selectionStyle = .none
        contentView.addSubviews([
            view,
            label,
            rightArrow
        ])
    }

    private func initialLayout() {
        view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).offset(-9)
            make.height.equalTo(42)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(16)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        rightArrow.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }
    }
}

extension RetrospectListCell {
    static let id: String = "\(RetrospectListCell.self)"
}
