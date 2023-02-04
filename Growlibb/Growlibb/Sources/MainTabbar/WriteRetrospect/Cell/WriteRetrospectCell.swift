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
    func updateTextView(_ cell:UITableViewCell, _ textView:UITextView)
}

class WriteRetrospectCell: UITableViewCell {
    
    var delegate: TextViewDelegate?

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup() // cell 세팅
        initialLayout() // cell 레이아웃 설정
        
        textView.delegate = self //길이에 따라서 아래로 늘어날 텍스트뷰 컨트롤
    }
    
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        self.textView.text = ""
        self.deleteButton.isHidden = true
    }
    
    var backGround = UIView().then { view in
        view.backgroundColor = .veryLightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }
    
    var textView = UITextView().then { view in
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.sizeToFit()
        view.showsVerticalScrollIndicator = false
        
        view.textContainerInset = UIEdgeInsets(top: 13, left: 21, bottom: 0, right: 0)

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
            make.height.equalTo(39)
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
}

extension WriteRetrospectCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegate {
            delegate.updateTextView(self, textView)
        }
    }
}