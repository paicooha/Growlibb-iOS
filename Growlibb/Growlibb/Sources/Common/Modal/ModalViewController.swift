//
//  CommonModalViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/01.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class ModalViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: ModalViewModel, whereFrom: String) {
        self.viewModel = viewModel
        self.whereFrom = whereFrom
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: ModalViewModel
    private var whereFrom: String

    private func viewModelInput() {
        sheet.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .subscribe()
        .disposed(by: disposeBag)

        view.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .subscribe()
        .disposed(by: disposeBag)
        
        noButton.rx.tap
            .bind(to: viewModel.inputs.no)
            .disposed(by: disposeBag)
        
        yesButton.rx.tap
            .subscribe({ _ in
                self.viewModel.inputs.yes.onNext(self.whereFrom)
            })
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var sheet = UIView().then { view in
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }
    
    private var emojiLabel = UILabel().then { label in
        label.font = .pretendardSemibold36
    }
    
    private var descriptionLabel = UILabel().then { label in
        label.font = .pretendardMedium16
        label.numberOfLines = 0
        label.textAlignment = .center
    }
    
    private var noButton = UIButton().then { button in
        button.backgroundColor = .veryLightBlue
        button.setTitleColor(.primaryBlue, for: .normal)
        button.setTitle(L10n.No.title, for: .normal)
        button.isHidden = false
        
        button.titleLabel?.font = .pretendardMedium16
        button.clipsToBounds = true
        button.layer.cornerRadius = 9
    }
    
    private var yesButton = ShortButton().then { button in
        button.setEnable()
        button.setTitle(L10n.Yes.title, for: .normal)
        button.titleLabel?.font = .pretendardMedium16
    }
}

// MARK: - Layout

extension ModalViewController {
    private func setupViews() {
        view.backgroundColor = .modalBgColor
        
        switch self.whereFrom {
        case "writeretrospect":
            emojiLabel.text = L10n.WriteRetrospect.Modal.NotYet.emoji
            descriptionLabel.text = L10n.WriteRetrospect.Modal.NotYet.title
        case "retrospect":
            emojiLabel.text = L10n.Retrospect.Modal.Event.emoji
        case "logout":
            emojiLabel.text = L10n.MyPage.Logout.emoji
            descriptionLabel.text = L10n.MyPage.Logout.title
        case "resign":
            break
        default:
            break
        }

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            emojiLabel,
            descriptionLabel,
            noButton,
            yesButton
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(200)
        }
        
        emojiLabel.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(30)
            make.centerX.equalTo(sheet.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiLabel.snp.bottom).offset(20)
            make.centerX.equalTo(sheet.snp.centerX)
        }
        
        noButton.snp.makeConstraints { make in
            make.bottom.equalTo(sheet.snp.bottom).offset(-15)
            make.trailing.equalTo(sheet.snp.centerX).offset(-3)
            make.width.equalTo(125)
            make.height.equalTo(39)
        }
        
        yesButton.snp.makeConstraints { make in
            make.bottom.equalTo(sheet.snp.bottom).offset(-15)
            make.leading.equalTo(sheet.snp.centerX).offset(3)
            make.width.equalTo(125)
            make.height.equalTo(39)
        }
        
        switch self.whereFrom {
        case "retrospect": //회고와 회원탈퇴일 경우에만 레이아웃이 다름
            break
        case "resign":
            break
        default:
            break
        }
    }
}
