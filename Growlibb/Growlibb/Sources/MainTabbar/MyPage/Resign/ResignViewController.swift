//
//  ResignViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class ResignViewController: BaseViewController {
    
    private var userKeyChainService: UserKeychainService

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()
        
        viewModelInput()
        viewModelOutput()
    }
    
    init(viewModel: ResignViewModel) {
        self.viewModel = viewModel
        self.userKeyChainService = BasicUserKeyChainService.shared
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: ResignViewModel
    
    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .subscribe(onNext: { _ in
//                self.getAllTextList()
//                self.viewModel.inputs.complete.onNext(PostRetrospectRequest(done: self.doneTextList, keep: self.keepTextList, problem: self.problemTextList, attempt: self.tryTextList))
            })
            .disposed(by: disposeBag)
    }
    
    private func viewModelOutput(){

    }
    
    private var navBar = NavBar().then { navBar in
        navBar.leftBtnItem.isHidden = false
        navBar.titleLabel.text = L10n.MyPage.List.resign
    }
    
    private var scrollView = UIScrollView().then { view in
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var contentView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var titleLabel = UILabel().then { view in
        view.font = .pretendardMedium14
    }
    
    private var guideLabel = UILabel().then { view in
        view.text = L10n.MyPage.Resign.guide
        view.font = .pretendardMedium12
        view.numberOfLines = 0
    }
    
    private var checkBox = UIButton().then { view in
        view.setImage(Asset.icCheckboxGray.image, for: .normal)
        view.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }
    }
    
    private var checkLabel = UILabel().then { view in
        view.text = L10n.MyPage.Resign.Checkbox.guide
        view.font = .pretendardRegular12
        view.textColor = .gray61
    }
    
    private var resignTitle = UILabel().then { view in
        view.text = L10n.MyPage.Resign.Reason.title
        view.font = .pretendardMedium14
    }
    
    private var resignSubTitle = UILabel().then { view in
        view.text = L10n.MyPage.Resign.Reason.subtitle
        view.font = .pretendardRegular12
        view.numberOfLines = 0
    }
    
    private var textView = UITextView().then { view in
        view.backgroundColor = .veryLightGray
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        
        view.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.sizeToFit()

        view.font = .pretendardMedium12
    }
    
    private var completeButton = LongButton().then { view in
        view.setDisable()
        view.setTitle(L10n.MyPage.List.resign, for: .normal)
    }
}

// MARK: - Layout

extension ResignViewController {
    private func setupViews() {
        
        titleLabel.text = "\(self.userKeyChainService.nickName)\(L10n.MyPage.Resign.title)"
        
        view.addSubviews([
            navBar,
            scrollView,
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            titleLabel,
            guideLabel,
            checkBox,
            checkLabel,
            resignTitle,
            resignSubTitle,
            textView,
            completeButton
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        contentView.snp.makeConstraints{ make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(41)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-40)
        }
        
        checkBox.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(20)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        checkLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkBox.snp.trailing).offset(11)
            make.centerY.equalTo(checkBox.snp.centerY)
        }
        
        resignTitle.snp.makeConstraints { make in
            make.top.equalTo(checkLabel.snp.bottom).offset(40)
            make.leading.equalTo(guideLabel.snp.leading)
        }
        
        resignSubTitle.snp.makeConstraints { make in
            make.leading.equalTo(resignTitle.snp.leading)
            make.top.equalTo(resignTitle.snp.bottom).offset(20)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(resignSubTitle.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(28)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.height.equalTo(220)
        }
        
        completeButton.snp.makeConstraints{ make in
            make.top.equalTo(textView.snp.bottom).offset(131)
            make.leading.equalTo(contentView.snp.leading).offset(28)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.bottom.equalTo(contentView.snp.bottom).offset(-42)
        }
    }
}
