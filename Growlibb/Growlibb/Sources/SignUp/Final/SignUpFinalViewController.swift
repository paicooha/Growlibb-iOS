//
//  SignUpFinalViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/21.
//

import RxCocoa
import RxGesture
import RxSwift
import Then
import UIKit
import SnapKit

final class SignUpFinalViewController: BaseViewController {
    
    var titleLabelString = "\(UserInfo.shared.nickName)\(L10n.SignUp.Final.title)"
    var attributedtitleLabelString = NSMutableAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupViews()
        initialLayout()

        viewModelInput()
//        viewModelOutput()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false // 뒤로 못넘어가게 수정
    }

    init(viewModel: SignUpFinalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: SignUpFinalViewModel

    private func viewModelInput() {
        nextButton.rx.tap
            .bind(to: viewModel.inputs.tapNext)
            .disposed(by: disposeBag)
    }
//
//    private func viewModelOutput() {
//
//        viewModel.toast
//            .subscribe(onNext: { message in
//                AppContext.shared.makeToast(message)
//            })
//            .disposed(by: disposeBag)
//    }

    private var navBar = NavBar().then{ make in
        make.leftBtnItem.isHidden = true
    }
    
    private var titleLabel = UILabel().then{ make in
        make.font = .pretendardSemibold20
        make.textColor = .black
        make.numberOfLines = 0
    }
    
    private var guideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Final.guidelabel
        make.textColor = .black
        make.font = .pretendardMedium12
    }
    
    private var nextButton = LongButton().then { make in
        make.setTitle(L10n.SignUp.Final.button, for: .normal)
        make.setEnable()
    }
}

// MARK: - Layout

extension SignUpFinalViewController {
    
    private func setupViews() {
        
        view.addSubviews([
            navBar,
            titleLabel,
            guideLabel,
            nextButton
        ])
        
        attributedtitleLabelString = NSMutableAttributedString(string: titleLabelString)
        attributedtitleLabelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.primaryBlue, range: NSRange(location: UserInfo.shared.nickName.count + 3, length: 4))
        
        titleLabel.attributedText = attributedtitleLabelString
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
                
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(navBar.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? 39 : 9)
            make.leading.equalTo(view.snp.leading).offset(28)
        }

        guideLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(43)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        nextButton.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -42 : -22)
        }
    }
}
