//
//  EditNotiViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/06.
//

import Foundation
import UIKit
import FirebaseMessaging

final class EditNotiViewController: BaseViewController {
    
    private var userKeyChainService = BasicUserKeyChainService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        
    }

    init(viewModel: EditNotiViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: EditNotiViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)
        
        alarmSwitch
             .rx.controlEvent(.valueChanged)
             .withLatestFrom(alarmSwitch.rx.value)
             .subscribe(onNext : { isOn in
                if isOn {
                    let fcmToken = Messaging.messaging().fcmToken ?? ""
                    if fcmToken.isEmpty {
                        AppContext.shared.makeToast("문제가 발생했습니다. 다시 시도해주세요")
                    }
                    else{
                        self.viewModel.inputs.pushSwitch.onNext(fcmToken)
                    }
                }
                else{
                    self.viewModel.inputs.pushSwitch.onNext(nil)
                }
            })
            .disposed(by: disposeBag)
        
    }

    private func viewModelOutput(){

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    
    }

    private var navBar = NavBar().then { navBar in
        navBar.leftBtnItem.isHidden = false
        navBar.rightBtnItem.isHidden = true
        navBar.titleLabel.isHidden = false
        navBar.titleLabel.text = L10n.MyPage.List.editNoti
    }
    
    private var contentView = UIView()
    
    private var titleLabel = UILabel().then { view in
        view.font = .pretendardSemibold16
        view.text = L10n.MyPage.editNoti
        
    }
    
    private var alarmSwitch = UISwitch().then { view in
        /*For on state*/
        view.onTintColor = .primaryBlue

        /*For off state*/
//        view.tintColor = .veryLightGray
        view.layer.cornerRadius = view.frame.height / 2.0
//        view.backgroundColor = .veryLightGray
        view.clipsToBounds = true
    }
    
    private var hDivider = UIView().then { view in
        view.backgroundColor = .veryLightGray
    }
}

// MARK: - Layout

extension EditNotiViewController {
    private func setupViews() {
        if userKeyChainService.fcmToken == "" {
            alarmSwitch.isOn = false
        }
        else{
            alarmSwitch.isOn = true
        }
        
        view.addSubviews([
            navBar,
            contentView,
            hDivider
        ])
        
        contentView.addSubviews([
            titleLabel, alarmSwitch
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(28)
            make.centerY.equalTo(contentView.snp.centerY)
            
        }
        
        alarmSwitch.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        hDivider.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
