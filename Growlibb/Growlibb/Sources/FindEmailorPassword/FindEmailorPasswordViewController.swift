//
//  FindEmailorPasswordViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/29.
//

import RxCocoa
import RxGesture
import RxSwift
import Then
import UIKit
import SnapKit
import Toast_Swift
import FirebaseAuth
import AnyFormatKit

final class FindEmailorPasswordViewController: BaseViewController {
    
    var phoneNumber = ""
    var verificationId = ""
    
    var authTime = 180 //3분
    var authTimer: Timer?
    
    var email = ""
    var userInfo = UserInfo()
    
    //하단 버튼 액션을 분기별로 처리하기 위함
    //순서대로 이메일찾기, 로그인화면 이동(이메일), 비밀번호 찾기, 로그인 화면 이동(비밀번호) -> 초기에는 이메일찾기이므로 1
    var buttonAction = [true, false, false, false]
    
    //'비밀번호 재설정' 탭에서 이메일, 인증번호 검증을 모두 통과했는지 여부에 대한 배열
    //차례대로 이메일, 인증번호
    var validCheckArray = [false, false]
    
    lazy var dataManager = FindDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initialLayout()

        viewModelInput()
//        viewModelOutput()
        
        findEmailauthcodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        findpasswordemailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        findpasswordauthcodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        findpasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        findpasswordConfirmTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        findEmailphoneTextField.delegate = self
        findpasswordphoneTextField.delegate = self
    }

    init(viewModel: FindEmailorPasswordViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
    
        if textField == findEmailauthcodeTextField {
            checkMaxLength(textField: textField, maxLength: 6)
            
            if textField.content?.count == 6{
                findEmailauthcodeButton.setEnable()
            }
            else{
                findEmailauthcodeButton.setDisable()
            }
        }
        else if textField == findpasswordemailTextField {
            if !Regex().isValidEmail(input: findpasswordemailTextField.content ?? " "){
                findpasswordEmailGuideLabel.isHidden = false
                findpasswordEmailGuideLabel.text = L10n.SignUp.Email.Guidelabel.notemail
                
                validCheckArray[0] = false
                
                bottomButton.setDisable() //추후에 다시 수정할 수 있으므로
            }
            else{ //이메일 도메인 길이 체크
                if ((findpasswordemailTextField.text?.components(separatedBy: "@").first?.count)! > 64) || ((findpasswordemailTextField.text?.components(separatedBy: "@")[1].count)! > 255){
                    findpasswordEmailGuideLabel.isHidden = false
                    findpasswordEmailGuideLabel.text = L10n.SignUp.Email.Guidelabel.toolong
                    validCheckArray[0] = false
                    
                    bottomButton.setDisable()
                }
                validCheckArray[0] = true
                findpasswordEmailGuideLabel.isHidden = true
                checkAllPass()
            }
        }
        else if textField == findpasswordauthcodeTextField {
            checkMaxLength(textField: textField, maxLength: 6)

            if textField.content?.count == 6{
                findpasswordauthcodeButton.setEnable()
            }
            else{
                findpasswordauthcodeButton.setDisable()
            }
        }
        else if textField == findpasswordTextField {
            if !Regex().isValidPassword(input: findpasswordTextField.content ?? " "){
                findpasswordGuideLabel.isHidden = false
            }
            else{
                findpasswordGuideLabel.isHidden = true
            }
            
            //비밀번호 입력창에서도 비밀번호 확인 입력창과 일치하는지 검증해야함
            if (textField.content ?? " ") != (findpasswordConfirmTextField.content ?? " ") && !(findpasswordConfirmTextField.content ?? "").isEmpty {
                findpasswordConfirmGuideLabel.isHidden = false
                
                bottomButton.setDisable()
            }
            else{
                findpasswordConfirmGuideLabel.isHidden = true
                bottomButton.setEnable()
            }
        }
        else if textField == findpasswordConfirmTextField {
            if textField.content ?? " " != findpasswordTextField.content ?? " " {
                findpasswordConfirmGuideLabel.isHidden = false
                bottomButton.setDisable()
            }
            else{
                bottomButton.setEnable()
                findpasswordConfirmGuideLabel.isHidden = true
            }
        }
    }
    
    @objc func findEmailauthtimerCallback() {
        findEmailauthTimerLabel.isHidden = false
        authTime -= 1
        findEmailauthTimerLabel.text = "\(Int((authTime / 60) % 60)):\(String(format:"%02d", Int(authTime % 60)))"
        
        if (authTime == 0){
            authTimer?.invalidate()
            findEmailauthcodeButton.setDisable()
            
            self.verificationId = "" //3분 지났을 시 인증번호 무효화
        }
    }
    
    @objc func findPasswordauthtimerCallback() {
        findpasswordauthTimerLabel.isHidden = false
        authTime -= 1
        findpasswordauthTimerLabel.text = "\(Int((authTime / 60) % 60)):\(String(format:"%02d", Int(authTime % 60)))"
        
        if (authTime == 0){
            authTimer?.invalidate()
            findpasswordauthcodeButton.setDisable()
            
            self.verificationId = ""
        }
    }
    
    func checkAllPass(){
        if validCheckArray.allSatisfy({$0}){ //모두 true
            bottomButton.setEnable()
        }
        else{
            print(validCheckArray)
            bottomButton.setDisable()
        }
    }

    private var viewModel: FindEmailorPasswordViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBag)
        
        idTab.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.idTab.isSelected = true
                self.tabMover.snp.removeConstraints()
                self.tabMover.snp.updateConstraints { make in
                    make.height.equalTo(2)
                    make.bottom.equalTo(tabDivider.snp.top)
                    make.leading.equalTo(idTab.snp.leading)
                    make.trailing.equalTo(idTab.snp.trailing)
                }
                self.passwordTab.isSelected = false
                
                emailFindView.isHidden = false
                emailFoundView.isHidden = true
                passwordFindView.isHidden = true
                passwordFoundView.isHidden = true
                
                findEmailphoneTextField.text = ""
                findEmailauthcodeTextField.text = ""
                findEmailauthGuideLabel.isHidden = true
                
                findEmailphoneButton.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)
                findEmailphoneButton.setDisable()
                findEmailauthcodeButton.setDisable()
                
                bottomButton.setDisable()
                
                buttonAction = [true, false, false, false]
                
                self.findTitle.text = L10n.Find.Email.Guide.title
            })
            .disposed(by: disposeBag)

        passwordTab.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.passwordTab.isSelected = true
                self.tabMover.snp.removeConstraints()
                self.tabMover.snp.updateConstraints { make in
                    make.height.equalTo(2)
                    make.bottom.equalTo(tabDivider.snp.top)
                    make.leading.equalTo(passwordTab.snp.leading)
                    make.trailing.equalTo(passwordTab.snp.trailing)
                }
                self.idTab.isSelected = false
                
                emailFindView.isHidden = true
                emailFoundView.isHidden = true
                passwordFindView.isHidden = false
                passwordFoundView.isHidden = true
                
                findpasswordemailTextField.text = ""
                findpasswordphoneTextField.text = ""
                findpasswordauthcodeTextField.text = ""
                findpasswordauthGuideLabel.isHidden = true
                
                findpasswordphoneButton.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)
                findpasswordphoneButton.setDisable()
                findpasswordauthcodeButton.setDisable()
                
                bottomButton.setDisable()
                
                buttonAction = [false, false, true, false]
                
                self.findTitle.text = L10n.Find.Password.Guide.title
            })
            .disposed(by: disposeBag)
        
        findEmailphoneButton.rx.tap
            .subscribe({ _ in
                //버튼 연타 방지
                self.findEmailphoneButton.setDisable()
                
                self.validCheckArray[0] = false //한번 더 인증할 수 있으므로 일단 false로 두기
                
                //휴대폰번호 중복 체크
                guard self.findEmailphoneTextField.content != nil else {
                    AppContext.shared.makeToast("휴대폰 번호를 올바르게 입력해주세요.")
                    return
                }
                
                self.dataManager.postFindEmail(viewController: self, phoneNumber: self.findEmailphoneTextField.content!)
                
            })
            .disposed(by: disposeBag)
        
        findEmailauthcodeButton.rx.tap
            .subscribe({ _ in
                
                guard self.findEmailauthcodeTextField.content != nil else {
                    AppContext.shared.makeToast("인증번호를 입력해주세요.")
                    return
                }
                
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationId,
                                                                         verificationCode: self.findEmailauthcodeTextField.content!)
                
                Auth.auth().signIn(with: credential) { (authData, error) in
                    if error != nil {
                        print("로그인 Error: \(error.debugDescription)")
                        self.findEmailauthGuideLabel.isHidden = false
                        return
                    }
                    self.findEmailauthGuideLabel.text = L10n.SignUp.Code.Correct.guidelabel
                    self.findEmailauthTimerLabel.isHidden = true
                    self.authTimer?.invalidate()
                    
                    print("인증성공 : \(authData)")
                    
                    self.bottomButton.setEnable()
                }
            })
            .disposed(by: disposeBag)
        
        findpasswordphoneButton.rx.tap
            .subscribe({ _ in
                //버튼 연타 방지
                self.findpasswordphoneButton.setDisable()
                
                guard self.findpasswordphoneTextField.content != nil else {
                    AppContext.shared.makeToast("휴대폰 번호를 입력해주세요.")
                    return
                }
                
                //휴대폰번호 중복 체크
                self.dataManager.postFindEmail(viewController: self, phoneNumber: self.findpasswordphoneTextField.content!)
            })
            .disposed(by: disposeBag)
        
        findpasswordauthcodeButton.rx.tap
            .subscribe({ _ in
                
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationId,
                                                                         verificationCode: self.findpasswordauthcodeTextField.text!)
                
                Auth.auth().signIn(with: credential) { (authData, error) in
                    if error != nil {
                        print("로그인 Error: \(error.debugDescription)")
                        self.findpasswordauthGuideLabel.isHidden = false
                        return
                    }
                    self.findpasswordauthGuideLabel.text = L10n.SignUp.Code.Correct.guidelabel
                    self.findpasswordauthTimerLabel.isHidden = true
                    self.authTimer?.invalidate()
                    
                    print("인증성공 : \(authData)")
                    
                    self.validCheckArray[1] = true
                    self.checkAllPass()
                }
            })
            .disposed(by: disposeBag)
        
        bottomButton.rx.tap
            .subscribe({ [self] _ in
                if self.buttonAction[0] {
                    self.findTitle.text = L10n.Find.Email.Find.title
                    self.emailFindView.isHidden = true
                    self.emailFoundView.isHidden = false
                    
                    self.foundemailTextField.text = self.email
                    
                    self.bottomButton.setTitle(L10n.Confirm.Button.title, for: .normal)
                    self.bottomButton.setEnable()
                    
                    self.buttonAction = [false, true, false, false]
                }
                else if self.buttonAction[1]{
                    self.viewModel.inputs.login.onNext(())
                }
                else if self.buttonAction[2]{
                    self.dataManager.postFindPassword(viewController:self, phoneNumber: self.findpasswordphoneTextField.text!, email: self.findpasswordemailTextField.text!)
                }
                else if self.buttonAction[3] {
                    self.userInfo.password = self.findpasswordTextField.text!
                    self.dataManager.postpatchPassword(viewController: self, userInfo: userInfo)
                }
            })
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
        make.leftBtnItem.isHidden = false
    }
    
    private var idTab = UIButton().then { button in
        button.setTitle(L10n.Find.Email.Tab.title, for: .selected)
        button.setTitleColor(.primaryBlue, for: .selected)
        button.backgroundColor = .clear
        button.setTitle(L10n.Find.Email.Tab.title, for: .normal)
        button.setTitleColor(.brownGray, for: .normal)
        button.titleLabel?.font = .pretendardSemibold20
        button.isSelected = true
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
    }

    private var passwordTab = UIButton().then { button in
        button.setTitle(L10n.Find.Password.Tab.title, for: .selected)
        button.setTitleColor(.primaryBlue, for: .selected)
        button.backgroundColor = .clear
        button.setTitle(L10n.Find.Password.Tab.title, for: .normal)
        button.setTitleColor(.brownGray, for: .normal)
        button.titleLabel?.font = .pretendardSemibold20
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
    }

    private var tabDivider = UIView().then { view in
        view.backgroundColor = .brownGray
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    private var tabMover = UIView().then { view in
        view.backgroundColor = .primaryBlue
        view.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
    }
    
    //이메일 찾기
    private var emailFindView = UIView().then { view in
        view.backgroundColor = .clear
        view.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }
    
    private var findTitle = UILabel().then { view in
        view.text = L10n.Find.Email.Guide.title
        view.textColor = .black
        view.font = .pretendardMedium14
        view.numberOfLines = 0
    }
    
    private var findEmailphoneTitleLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Phone.title
    }
    
    private var findEmailphoneTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Phone.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
            //placeholder 색 바꾸기
        make.keyboardType = .phonePad
    }
    
    private var findEmailphoneButton = ShortButton().then { make in
        make.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)
        make.setDisable()
    }
    
    private var findEmailphoneGuideLabel = UILabel().then{ make in
        make.font = .pretendardMedium12
        make.textColor = .primaryBlue
        make.text = L10n.Find.Email.Notfind.guidelabel
        make.isHidden = true
    }
    
    private var findEmailauthcodeLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Code.title
    }
    
    private var findEmailauthcodeTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Code.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
        make.keyboardType = .numberPad
    }
    
    private var findEmailauthTimerLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .primaryBlue
        make.isHidden = true
    }
    
    private var findEmailauthcodeButton = ShortButton().then { make in
        make.setTitle(L10n.Confirm.Button.title, for: .normal)
        make.setDisable()
    }
    
    private var findEmailauthGuideLabel = UILabel().then{ make in
        make.font = .pretendardMedium12
        make.textColor = .primaryBlue
        make.text = L10n.SignUp.Code.guidelabel
        make.isHidden = true
    }
    
    private var findEmailcodeConfirmGuideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Code.guidelabel
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    //이메일 찾음
    private var emailFoundView = UIView().then { view in
        view.backgroundColor = .clear
        view.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        view.isHidden = true
    }
    
    private var foundemailTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Email.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var foundemailTextField = TextField().then { make in
        make.isEnabled = false //입력 못하게 막기
    }
    
    //비밀번호 찾기
    private var passwordFindView = UIView().then { view in
        view.backgroundColor = .clear
        view.snp.makeConstraints { make in
            make.height.equalTo(350)
        }
        view.isHidden = true
    }
    
    private var findpasswordemailLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Email.title
    }
    
    private var findpasswordemailTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Email.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
        make.keyboardType = .emailAddress
    }
    
    private var findpasswordEmailGuideLabel = UILabel().then{ make in
        make.font = .pretendardMedium12
        make.textColor = .primaryBlue
        make.text = L10n.Find.Password.Notfind.guidelabel
        make.isHidden = true
    }
    
    private var findpasswordpasswordTitle = UILabel().then { view in
//        view.text = L10n.Find.Password.Guide.title
        view.textColor = .black
        view.font = .pretendardMedium14
    }
    
    private var findpasswordphoneTitleLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Phone.title
    }
    
    private var findpasswordphoneTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Phone.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
            //placeholder 색 바꾸기
        make.keyboardType = .phonePad
    }
    
    private var findpasswordphoneGuideLabel = UILabel().then{ make in
        make.text = L10n.Find.Email.Notfind.guidelabel
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    private var findpasswordphoneButton = ShortButton().then { make in
        make.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)
        make.setDisable()
    }
    
    private var findpasswordauthcodeLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Code.title
    }
    
    private var findpasswordauthcodeTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Code.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
        make.keyboardType = .numberPad
    }
    
    private var findpasswordauthTimerLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .primaryBlue
        make.isHidden = true
    }
    
    private var findpasswordauthcodeButton = ShortButton().then { make in
        make.setTitle(L10n.Confirm.Button.title, for: .normal)
        make.setDisable()
    }
    
    private var findpasswordauthGuideLabel = UILabel().then{ make in
        make.font = .pretendardMedium12
        make.textColor = .primaryBlue
        make.text = L10n.SignUp.Code.guidelabel
        make.isHidden = true
    }
    
    //비밀번호 찾음
    private var passwordFoundView = UIView().then { view in
        view.backgroundColor = .clear
        view.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        view.isHidden = true
    }
    
    private var findpasswordTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Password.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var findpasswordTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Password.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
            //placeholder 색 바꾸기
        make.isSecureTextEntry = true //비밀번호 *로 표시
        
    }
    
    private var findpasswordGuideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Password.guidelabel
        make.numberOfLines = 0
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    private var findpasswordConfirmTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Passwordconfirm.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var findpasswordConfirmTextField = TextField().then { make in
        make.isSecureTextEntry = true //비밀번호 *로 표시
        
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Passwordconfirm.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
    }
    
    private var findpasswordConfirmGuideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Passwordconfirm.guidelabel
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    private var bottomButton = LongButton().then { make in
        make.setTitle(L10n.Next.Button.title, for: .normal)
        make.setDisable()
    }
}

// MARK: - Layout

extension FindEmailorPasswordViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            idTab,
            passwordTab,
            tabMover,
            tabDivider,
            findTitle,
            emailFindView,
            emailFoundView,
            passwordFindView,
            passwordFoundView,
            bottomButton
        ])
        
        emailFindView.addSubviews([
            findEmailphoneTitleLabel,
            findEmailphoneTextField,
            findEmailphoneButton,
            findEmailphoneGuideLabel,
            findEmailauthcodeLabel,
            findEmailauthcodeTextField,
            findEmailauthcodeButton,
            findEmailauthTimerLabel,
            findEmailauthGuideLabel
        ])
        
        emailFoundView.addSubviews([
            foundemailTitleLabel,
            foundemailTextField
        ])
        
        passwordFindView.addSubviews([
            findpasswordemailLabel,
            findpasswordemailTextField,
            findpasswordEmailGuideLabel,
            findpasswordphoneTitleLabel,
            findpasswordphoneTextField,
            findpasswordphoneGuideLabel,
            findpasswordphoneButton,
            findpasswordauthcodeLabel,
            findpasswordauthcodeButton,
            findpasswordauthGuideLabel,
            findpasswordauthcodeTextField,
            findpasswordauthTimerLabel,
        ])
        
        passwordFoundView.addSubviews([
            findpasswordTitleLabel,
            findpasswordTextField,
            findpasswordGuideLabel,
            findpasswordConfirmTitleLabel,
            findpasswordConfirmTextField,
            findpasswordConfirmGuideLabel
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        idTab.snp.makeConstraints{ make in
            make.top.equalTo(navBar.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.centerX)
        }
        
        passwordTab.snp.makeConstraints{ make in
            make.top.equalTo(idTab.snp.top)
            make.leading.equalTo(idTab.snp.trailing)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        tabDivider.snp.makeConstraints{ make in
            make.top.equalTo(idTab.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        tabMover.snp.makeConstraints{ make in
            make.bottom.equalTo(tabDivider.snp.top)
            make.leading.equalTo(idTab.snp.leading)
            make.trailing.equalTo(idTab.snp.trailing)
        }
        
        findTitle.snp.makeConstraints{ make in
            make.top.equalTo(tabDivider.snp.bottom).offset(33)
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        emailFindView.snp.makeConstraints{ make in
            make.top.equalTo(findTitle.snp.bottom).offset(57)
            make.leading.equalTo(findTitle.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        findEmailphoneTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(emailFindView.snp.top)
            make.leading.equalTo(emailFindView.snp.leading)
        }
        
        findEmailphoneTextField.snp.makeConstraints{ make in
            make.top.equalTo(findEmailphoneTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(findEmailphoneTitleLabel.snp.leading)
            make.trailing.equalTo(findEmailphoneButton.snp.leading).offset(-14)
        }
        
        findEmailphoneButton.snp.makeConstraints{ make in
            make.centerY.equalTo(findEmailphoneTextField.snp.centerY)
            make.width.equalTo(98)
            make.trailing.equalTo(emailFindView.snp.trailing)
        }
        
        findEmailphoneGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(findEmailphoneTextField.snp.bottom).offset(4)
            make.leading.equalTo(findEmailphoneTextField.snp.leading)
        }
        
        findEmailauthcodeLabel.snp.makeConstraints{ make in
            make.top.equalTo(findEmailphoneTextField.snp.bottom).offset(36)
            make.leading.equalTo(findEmailphoneTitleLabel.snp.leading)
        }
        
        findEmailauthcodeTextField.snp.makeConstraints{ make in
            make.top.equalTo(findEmailauthcodeLabel.snp.bottom).offset(5)
            make.leading.equalTo(findEmailauthcodeLabel.snp.leading)
            make.trailing.equalTo(findEmailauthcodeButton.snp.leading).offset(-14)
        }
        
        findEmailauthcodeButton.snp.makeConstraints{ make in
            make.centerY.equalTo(findEmailauthcodeTextField.snp.centerY)
            make.width.equalTo(98)
            make.trailing.equalTo(emailFindView.snp.trailing)
        }
        
        findEmailauthTimerLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(findEmailauthcodeTextField.snp.centerY)
            make.trailing.equalTo(findEmailauthcodeTextField.snp.trailing).offset(-20)
        }
        
        findEmailauthGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(findEmailauthcodeTextField.snp.bottom).offset(5)
            make.leading.equalTo(findEmailauthcodeTextField.snp.leading)
        }
        
        emailFoundView.snp.makeConstraints{ make in
            make.top.equalTo(findTitle.snp.bottom).offset(57)
            make.leading.equalTo(findTitle.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        foundemailTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(emailFoundView.snp.top)
            make.leading.equalTo(emailFoundView.snp.leading)
        }
        
        foundemailTextField.snp.makeConstraints{ make in
            make.top.equalTo(foundemailTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(foundemailTitleLabel.snp.leading)
            make.trailing.equalTo(emailFoundView.snp.trailing)
        }
        
        passwordFindView.snp.makeConstraints{ make in
            make.top.equalTo(tabDivider.snp.bottom).offset(108)
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        findpasswordemailLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordFindView.snp.top)
            make.leading.equalTo(passwordFindView.snp.leading)
        }
        
        findpasswordemailTextField.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordemailLabel.snp.bottom).offset(5)
            make.leading.equalTo(findpasswordemailLabel.snp.leading)
            make.trailing.equalTo(passwordFindView.snp.trailing)
        }
        
        findpasswordEmailGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordemailTextField.snp.bottom).offset(4)
            make.leading.equalTo(findpasswordemailLabel.snp.leading)
        }
        
        findpasswordphoneTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordemailTextField.snp.bottom).offset(36)
            make.leading.equalTo(findpasswordEmailGuideLabel.snp.leading)
        }
        
        findpasswordphoneTextField.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordphoneTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(findpasswordphoneTitleLabel.snp.leading)
            make.trailing.equalTo(findpasswordphoneButton.snp.leading).offset(-14)
        }
        
        findpasswordphoneGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordphoneTextField.snp.bottom).offset(4)
            make.leading.equalTo(findpasswordphoneTitleLabel.snp.leading)
        }
        
        findpasswordphoneButton.snp.makeConstraints{ make in
            make.centerY.equalTo(findpasswordphoneTextField.snp.centerY)
            make.width.equalTo(98)
            make.trailing.equalTo(passwordFindView.snp.trailing)
        }
        
        findpasswordauthcodeLabel.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordphoneTextField.snp.bottom).offset(36)
            make.leading.equalTo(findpasswordphoneGuideLabel.snp.leading)
        }
        
        findpasswordauthcodeTextField.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordauthcodeLabel.snp.bottom).offset(5)
            make.leading.equalTo(findpasswordauthcodeLabel.snp.leading)
            make.trailing.equalTo(findpasswordauthcodeButton.snp.leading).offset(-14)
        }
        
        findpasswordauthcodeButton.snp.makeConstraints{ make in
            make.centerY.equalTo(findpasswordauthcodeTextField.snp.centerY)
            make.width.equalTo(98)
            make.trailing.equalTo(passwordFindView.snp.trailing)
        }
        
        findpasswordauthTimerLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(findpasswordauthcodeTextField.snp.centerY)
            make.trailing.equalTo(findpasswordauthcodeTextField.snp.trailing).offset(-20)
        }
        
        findpasswordauthGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordauthcodeTextField.snp.bottom).offset(5)
            make.leading.equalTo(findpasswordauthcodeTextField.snp.leading)
        }
        
        passwordFoundView.snp.makeConstraints{ make in
            make.top.equalTo(tabDivider.snp.bottom).offset(108)
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        findpasswordTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordFoundView.snp.top)
            make.leading.equalTo(passwordFoundView.snp.leading)
        }
        
        findpasswordTextField.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(findpasswordTitleLabel.snp.leading)
            make.trailing.equalTo(passwordFoundView.snp.trailing)
        }
        
        findpasswordGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordTextField.snp.bottom).offset(4)
            make.leading.equalTo(findpasswordTitleLabel.snp.leading)
        }
        
        findpasswordConfirmTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordTextField.snp.bottom).offset(36)
            make.leading.equalTo(findpasswordGuideLabel.snp.leading)
        }
        
        findpasswordConfirmTextField.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordConfirmTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(findpasswordConfirmTitleLabel.snp.leading)
            make.trailing.equalTo(passwordFoundView.snp.trailing)
        }
        
        findpasswordConfirmGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(findpasswordConfirmTextField.snp.bottom).offset(4)
            make.leading.equalTo(findpasswordConfirmTitleLabel.snp.leading)
        }
        
        bottomButton.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -42 : -22)
        }
        
    }
}

extension FindEmailorPasswordViewController {
    
    func didSuccessFindEmail(response: PostFindEmailResponse){
        switch response.code {
        case 1000:
            
            if buttonAction[0]{
                self.findEmailphoneGuideLabel.isHidden = true
                email = response.result!.email
                
                self.authTimer?.invalidate()

                //인증코드 타이머
                self.authTime = 180
                self.authTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.findEmailauthtimerCallback), userInfo: nil, repeats: true)
                
                self.findEmailphoneButton.setTitle(L10n.SignUp.Phone.resendCode, for: .normal)
                self.phoneNumber = "+82\(self.findEmailphoneTextField.text!.replacingOccurrences(of: "-", with: "").suffix(10))"
                print(self.phoneNumber)
                
                
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber(self.phoneNumber, uiDelegate: nil) { verificationID, error in
                      if let error = error {
                          AppContext.shared.makeToast("인증번호 전송에 실패하였습니다. 다시 시도해주세요.")
                          print(error)
                        return
                      }
                      // 에러가 없다면 사용자에게 인증코드와 verificationID(인증ID) 전달
                        self.verificationId = verificationID!
                        self.findEmailphoneButton.setEnable()
                  }
            }
            else{
                self.findpasswordphoneGuideLabel.isHidden = true
                self.authTimer?.invalidate()

                //인증코드 타이머
                self.authTime = 180
                self.authTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.findPasswordauthtimerCallback), userInfo: nil, repeats: true)
                
                self.findpasswordphoneButton.setTitle(L10n.SignUp.Phone.resendCode, for: .normal)
                self.phoneNumber = "+82\(self.findpasswordphoneTextField.text!.replacingOccurrences(of: "-", with: "").suffix(10))"
                print(self.phoneNumber)
                
                
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber(self.phoneNumber, uiDelegate: nil) { verificationID, error in
                      if let error = error {
                          AppContext.shared.makeToast("인증번호 전송에 실패하였습니다. 다시 시도해주세요.")
                          print(error)
                        return
                      }
                      // 에러가 없다면 사용자에게 인증코드와 verificationID(인증ID) 전달
                        self.verificationId = verificationID!
                        self.findpasswordphoneButton.setEnable()
                  }
            }
            break
            
        case 2013:
            if buttonAction[0]{
                self.findEmailphoneButton.setDisable()
                findEmailphoneGuideLabel.isHidden = false
            }
            else{
                self.findpasswordphoneButton.setDisable()
                findpasswordphoneGuideLabel.isHidden = false
            }
        default:
            break
        }
    }
    
    func didSuccessFindPassword(code: Int){
        switch code{
        case 1000:
            buttonAction = [false, false, false, true]
            passwordFindView.isHidden = true
            passwordFoundView.isHidden = false
            
            self.findTitle.text = L10n.Find.Password.Find.title
            self.bottomButton.setTitle(L10n.Modify.title, for: .normal)
            self.bottomButton.setDisable()
            
            userInfo.email = self.findpasswordemailTextField.text!
            userInfo.phoneNumber = self.findpasswordphoneTextField.text!
            
        case 2013:
            self.validCheckArray[0] = false
            self.bottomButton.setDisable()
            
            self.findpasswordEmailGuideLabel.isHidden = false
            self.findpasswordEmailGuideLabel.text = L10n.Find.Password.Notfind.guidelabel
        default:
            break
        }
    }
    
    func didSuccessPatchPassword(code: Int){
        switch code{
        case 1000:
            viewModel.inputs.login.onNext(())
            AppContext.shared.makeToast("비밀번호 재설정이 완료되었습니다.")
        default:
            break
        }
    }
    
    func failedToRequest(message: String) {
        
        AppContext.shared.makeToast(message)
    }
}

extension FindEmailorPasswordViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return false
        }
        let characterSet = CharacterSet(charactersIn: string)
        if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
            return false
        }

        let formatter = DefaultTextInputFormatter(textPattern: "###-####-####") //포맷 제한
        let result = formatter.formatInput(currentText: text, range: range, replacementString: string)
        textField.text = result.formattedText
        let position = textField.position(from: textField.beginningOfDocument, offset: result.caretBeginOffset)!
        textField.selectedTextRange = textField.textRange(from: position, to: position)
        
        let textFieldText = textField.content ?? ""
        if (textFieldText.replacingOccurrences(of: "-", with: "").count) < 11 { //'-' 제외하고 11자리 미만일때
            if (textField == findEmailphoneTextField){
                findEmailphoneButton.setDisable()
                findEmailphoneButton.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)
            }
            else{
                findpasswordphoneButton.setDisable()
                findpasswordphoneButton.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)
            }
            bottomButton.setDisable()
        }
        else{
            if (textField == findEmailphoneTextField){
                findEmailphoneButton.setEnable()
            }
            else{
                findpasswordphoneButton.setEnable()
            }
        }
        
        return false
    }
}
