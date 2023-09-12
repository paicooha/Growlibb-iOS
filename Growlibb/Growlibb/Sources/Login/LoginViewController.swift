//
//  LoginViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import RxCocoa
import RxGesture
import RxSwift
import Then
import UIKit
import SnapKit
import Toast_Swift
import FirebaseMessaging

final class LoginViewController: BaseViewController {
    
    lazy var loginDataManager = LoginDataManager()
    private var loginKeyChainService: LoginKeyChainService
    private var userKeyChainService: UserKeychainService

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initialLayout()

        viewModelInput()
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !emailTextField.isEmpty() && !passwordTextField.isEmpty() {
            loginButton.setEnable()
        }
        else{
            loginButton.setDisable()
        }
    }

    init(viewModel: LoginViewModel, loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
         userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared) {
        self.viewModel = viewModel
        self.loginKeyChainService = BasicLoginKeyChainService.shared
        self.userKeyChainService = BasicUserKeyChainService.shared
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: LoginViewModel

    private func viewModelInput() {
        goToSignupLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.viewModel.inputs.goToSignup.onNext(())
            })
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { _ in
                guard (self.emailTextField.content != nil), (self.passwordTextField.content != nil) else {
                    AppContext.shared.makeToast("ID와 비밀번호 모두 입력해주세요.")
                    return
                }
                self.loginDataManager.postLogin(viewController: self, email: self.emailTextField.content!, password: self.passwordTextField.content!)
            })
            .disposed(by: disposeBag)
        
        findEmailorPasswordLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.viewModel.inputs.goToFindEmailorPassword.onNext(())
            })
            .disposed(by: disposeBag)
    }

    private var navBar = NavBar()
    
    private var titleLabel = UILabel().then{ make in
        make.font = .pretendardSemibold20
        make.textColor = .black
        make.text = L10n.Login.title
        make.numberOfLines = 0
    }
    
    private var emailTitleLabel = UILabel().then{ make in
        make.textColor = .black
        make.font = .pretendardMedium14
        make.text = L10n.Login.Email.title
    }
    
    private var emailTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.Login.Email.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
        
    }
    
    private var passwordTitleLabel = UILabel().then{ make in
        make.text = L10n.Login.Password.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var passwordTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.Login.Password.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
            //placeholder 색 바꾸기
        make.isSecureTextEntry = true //비밀번호 *로 표시
    }
    
    private var retryGuideLabel = UILabel().then{ make in
        make.font = .pretendardMedium12
        make.textColor = .primaryBlue
        make.isHidden = true
        make.text = L10n.Login.Incorrect.guidelabel
    }
    
    private var notMemberTitleLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.Login.Notmember.title
    }
    
    private var goToSignupLabel = UILabel().then{ make in
        make.font = .pretendardMedium12
        make.textColor = .primaryBlue
        make.text = L10n.Login.Notmember.gotoSignup
    }
    
    private var forgotTitleLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.Login.Forget.title
    }
    
    private var findEmailorPasswordLabel = UILabel().then{ make in
        make.font = .pretendardMedium12
        make.textColor = .primaryBlue
        make.text = L10n.Login.Forget.find
    }
    
    private var loginButton = LongButton().then { make in
        make.backgroundColor = .brownGray
        make.titleLabel?.font = .pretendardSemibold20
        make.titleLabel?.textColor = .veryLightGray
        make.setTitle(L10n.Login.Button.title, for: .normal)
        make.isEnabled = false
    }
}

// MARK: - Layout

extension LoginViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            titleLabel,
            emailTitleLabel,
            emailTextField,
            passwordTitleLabel,
            passwordTextField,
            retryGuideLabel,
            notMemberTitleLabel,
            goToSignupLabel,
            forgotTitleLabel,
            findEmailorPasswordLabel,
            loginButton
        ])
        
        titleLabel.attributedText = NSMutableAttributedString(string: L10n.Login.title)
            .addBlueStringStyleToRange(ranges: [NSRange(location: 6, length: 9)])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(navBar.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? 30 : 0)
            make.leading.equalTo(view.snp.leading).offset(28)
        }
        
        emailTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        emailTextField.snp.makeConstraints{ make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(emailTitleLabel.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        passwordTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(emailTextField.snp.bottom).offset(36)
            make.leading.equalTo(emailTextField.snp.leading)
        }
        
        passwordTextField.snp.makeConstraints{ make in
            make.top.equalTo(passwordTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(passwordTitleLabel.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        retryGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.leading.equalTo(passwordTextField.snp.leading)
        }
        
        notMemberTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(55)
            make.leading.equalTo(passwordTextField.snp.leading)
        }
        
        goToSignupLabel.snp.makeConstraints{ make in
            make.top.equalTo(notMemberTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(notMemberTitleLabel.snp.leading)
        }
        
        forgotTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(goToSignupLabel.snp.bottom).offset(27)
            make.leading.equalTo(goToSignupLabel.snp.leading)
        }
        
        findEmailorPasswordLabel.snp.makeConstraints{ make in
            make.top.equalTo(forgotTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(forgotTitleLabel.snp.leading)
        }
        
        loginButton.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -52 : -22)
        }
    }
}

extension LoginViewController {
    func didSuccessLogin(result: PostLoginResult) {
        self.loginKeyChainService.setLoginInfo(loginType: LoginType.member, userID: result.userId, token: LoginToken(jwt: result.jwt))
        self.userKeyChainService.nickName = result.nickname
        self.userKeyChainService.fcmToken = Messaging.messaging().fcmToken ?? ""
        self.userKeyChainService.level = result.seedLevel
        
        viewModel.inputs.loginSuccess.onNext(())
        retryGuideLabel.isHidden = true
    }
    
    func didFailLogin(){
        retryGuideLabel.isHidden = false
    }

    func failedToRequest(message: String) {
        
        AppContext.shared.makeToast(message)
    }
}
