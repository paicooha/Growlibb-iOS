//
//  WriteRetrospectCell.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/31.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

protocol TextViewDelegate {
    func textViewDidChange(_ cell:WriteRetrospectCell,_ textView:UITextView)
}

final class WriteRetrospectCell: UITableViewCell {
    
    var delegate: TextViewDelegate?
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup() // cell 세팅
        initialLayout() // cell 레이아웃 설정
        textView.delegate = self
    }
    
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    var id: Int?
    
    var backGround = UIView().then { view in
        view.backgroundColor = .veryLightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }
    
    var textView = UITextView().then { view in
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        
        view.textContainerInset = UIEdgeInsets(top: 13, left: 21, bottom: 12, right: 0)
        view.sizeToFit()

        view.font = .pretendardMedium12
    }
    
    var deleteButton = UIButton().then { view in
        view.setImage(Asset.icRetrospectDelete.image, for: .normal)
        view.snp.makeConstraints{ make in
            make.width.height.equalTo(20)
        }
        view.isHidden = true
    }
}

extension WriteRetrospectCell {
    private func setup() {
        selectionStyle = .none

        contentView.addSubviews([
            backGround,
            deleteButton,
            textView
        ])
    }

    private func initialLayout() {
        backGround.snp.makeConstraints{ make in
            make.top.equalTo(self.contentView.snp.top)
            make.leading.equalTo(self.contentView.snp.leading)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-5)
        }
        
        textView.snp.makeConstraints{ make in
            make.top.equalTo(backGround.snp.top)
            make.leading.equalTo(backGround.snp.leading)
            make.trailing.equalTo(backGround.snp.trailing).offset(-36)
            make.bottom.equalTo(backGround.snp.bottom)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(backGround.snp.centerY)
            make.trailing.equalTo(backGround.snp.trailing).offset(-10)
        }
    }
}

extension WriteRetrospectCell {
    static let id: String = "\(WriteRetrospectCell.self)"
    static let height: Int = 44
}

extension WriteRetrospectCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegate {
            delegate.textViewDidChange(self, textView)
        }
    }
}
