//
//  SignUpViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/13.
//

import RxCocoa
import RxGesture
import RxSwift
import Then
import UIKit
import SnapKit
import FirebaseAuth
import AnyFormatKit
import SafariServices

class SignUpFirstViewController: BaseViewController {
        
    var phoneNumber = ""
    var verificationId = ""
    
    var authTime = 180 //3분
    var authTimer: Timer?
    
    //아이디, 비밀번호, 인증번호, 약관동의를 모두 했는지 확인하기 위한 배열
    var validCheckArray = [false, false, false, false]
    
    //약관동의 - 서비스, 개인정보처리방침 약관동의, 만 14세 이상 여부를 확인하기 위한 배열
    var termsOfUseArray = [false, false, false]
    
    lazy var signUpDataManager = SignUpDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initialLayout()
        
        viewModelInput()
    }
    
    override func viewWillAppear(_ animated: Bool) { //다시 돌아올때 인증번호 초기화
        authTime = 180
        validCheckArray[2] = false
        
        authcodeTextField.text = ""
        authGuideLabel.isHidden = true
        
        if phoneTextField.isEmpty() { //2번째 화면에서 인증했다가 다시 돌아온 상황이 아니라면 disable 상태
            phoneButton.setDisable()
        }
        phoneButton.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)
        
        authcodeButton.setDisable()
        nextButton.setDisable()
    }
    
    init(viewModel: SignUpFirstViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == emailTextField {
            if !Regex().isValidEmail(input: emailTextField.content ?? " "){
                emailGuideLabel.isHidden = false
                emailGuideLabel.text = L10n.SignUp.Email.Guidelabel.notemail
                validCheckArray[0] = false
                
                nextButton.setDisable() //후에 다시수정할 수 있으므로
            }
            else{ //이메일 도메인 길이 체크
                if ((emailTextField.content?.components(separatedBy: "@").first?.count)! > 64) || ((emailTextField.content?.components(separatedBy: "@")[1].count)! > 255){
                    emailGuideLabel.isHidden = false
                    emailGuideLabel.text = L10n.SignUp.Email.Guidelabel.toolong
                    validCheckArray[0] = false
                    
                    nextButton.setDisable()
                }
                else{
                    validCheckArray[0] = true
                    emailGuideLabel.isHidden = true
                    
                    checkAllPass()
                }
            }
        }
        else if textField == passwordTextField {
            if !Regex().isValidPassword(input: passwordTextField.content ?? " "){
                passwordGuideLabel.isHidden = false
            }
            else{
                passwordGuideLabel.isHidden = true
            }
            
            //비밀번호 입력창에서도 비밀번호 확인 입력창과 일치하는지 검증해야함
            if textField.content ?? " " != passwordConfirmTextField.content ?? " " && !(passwordConfirmTextField.isEmpty()) {
                passwordConfirmGuideLabel.isHidden = false
                validCheckArray[1] = false
                
                nextButton.setDisable()
            }
            else{
                passwordConfirmGuideLabel.isHidden = true
                validCheckArray[1] = true
                checkAllPass()
            }
        }
        else if textField == passwordConfirmTextField {
            if textField.content ?? " " != passwordTextField.content ?? " " {
                passwordConfirmGuideLabel.isHidden = false
                validCheckArray[1] = false
                nextButton.setDisable()
            }
            else{
                passwordConfirmGuideLabel.isHidden = true
                validCheckArray[1] = true
                checkAllPass()
            }
        }
        else if textField == authcodeTextField {
            checkMaxLength(textField: textField, maxLength: 6)
            
            if textField.content?.count == 6{
                authcodeButton.setEnable()
            }
            else{
                authcodeButton.setDisable()
            }
        }
    }
    
    @objc func authtimerCallback() {
        authTimerLabel.isHidden = false
        authTime -= 1
        authTimerLabel.text = "\(Int((authTime / 60) % 60)):\(String(format:"%02d", Int(authTime % 60)))"
        
        if (authTime == 0){
            authTimer?.invalidate()
            authcodeButton.setDisable()
            
            self.verificationId = "" //3분지났을 시 인증번호 무효화
        }
    }

    private var viewModel: SignUpFirstViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBag)
        
        phoneButton.rx.tap
            .subscribe({ _ in
                //버튼 연타 방지 -> 인증번호 콜백시 활성화하도록 수정
                self.phoneButton.setDisable()
                self.authGuideLabel.isHidden = true
                self.validCheckArray[2] = false //한번 더 인증할 수 있으므로 일단 false로 두기
                
                guard self.phoneTextField.content != nil else {
                    
                    AppContext.shared.makeToast("휴대폰 번호를 입력해주세요.")
                    return
                }
                //휴대폰번호 중복 체크
                self.signUpDataManager.postCheckPhone(viewController: self, phoneNumber: self.phoneTextField.content!)
            })
            .disposed(by: disposeBag)
        
        authcodeButton.rx.tap
            .subscribe({ _ in
                
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationId,
                                                                         verificationCode: self.authcodeTextField.text!)
                
                Auth.auth().signIn(with: credential) { (authData, error) in
                    if error != nil {
                        print("로그인 Error: \(error.debugDescription)")
                        self.authGuideLabel.isHidden = false
                        return
                    }
                    self.authGuideLabel.isHidden = false
                    self.authGuideLabel.text = L10n.SignUp.Code.Correct.guidelabel //인증완료 텍스트 띄우기
                    self.authTimerLabel.isHidden = true
                    self.authTimer?.invalidate()
                    
                    self.validCheckArray[2] = true

                    print("인증성공 : \(authData)")
                    self.checkAllPass()
                }
            })
            .disposed(by: disposeBag)
        
        allAgreeButton.rx.tap
            .subscribe({ _ in
                if self.validCheckArray[3]{
                    self.validCheckArray[3] = false
                    self.termsOfUseArray = [false, false, false]
                    
                    self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal)
                    self.serviceButton.setImage(Asset.icCheckboxGray.image, for: .normal)
                    self.privacyButton.setImage(Asset.icCheckboxGray.image, for: .normal)
                    self.year14Button.setImage(Asset.icCheckboxGray.image, for: .normal)
                }
                else{
                    self.validCheckArray[3] = true
                    self.termsOfUseArray = [true, true, true]

                    self.allAgreeButton.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    self.serviceButton.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    self.privacyButton.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    self.year14Button.setImage(Asset.icCheckboxBlue.image, for: .normal)
                }
                self.checkAllPass()
            })
            .disposed(by: disposeBag)
        
        allAgreeTitle.rx.tapGesture()
            .when(.recognized)
            .subscribe({ _ in
                if self.validCheckArray[3]{
                    self.validCheckArray[3] = false
                    self.termsOfUseArray = [false, false, false]
                    
                    self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal)
                    self.serviceButton.setImage(Asset.icCheckboxGray.image, for: .normal)
                    self.privacyButton.setImage(Asset.icCheckboxGray.image, for: .normal)
                    self.year14Button.setImage(Asset.icCheckboxGray.image, for: .normal)
                }
                else{
                    self.validCheckArray[3] = true
                    self.termsOfUseArray = [true, true, true]

                    self.allAgreeButton.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    self.serviceButton.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    self.privacyButton.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    self.year14Button.setImage(Asset.icCheckboxBlue.image, for: .normal)
                }
                self.checkAllPass()
            })
            .disposed(by: disposeBag)
        
        serviceButton.rx.tap
            .subscribe({ _ in
                if self.termsOfUseArray[0]{ //on -> off
                    self.termsOfUseArray[0] = false
                    self.validCheckArray[3] = false
                    self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    self.serviceButton.setImage(Asset.icCheckboxGray.image, for: .normal)
                }
                else{ //off -> on
                    self.termsOfUseArray[0] = true
                    self.serviceButton.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    
                    if self.termsOfUseArray.allSatisfy({ $0 == true}) {
                        self.validCheckArray[3] = true
                        self.allAgreeButton.setImage(Asset.icCheckboxBlue.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }
                    else{
                        self.validCheckArray[3] = false
                        self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }

                }
                self.checkAllPass()
            })
            .disposed(by: disposeBag)
        
        serviceAgreeTitle.rx.tapGesture()
            .when(.recognized)
            .subscribe({ _ in
                if self.termsOfUseArray[0]{ //on -> off
                    self.termsOfUseArray[0] = false
                    self.validCheckArray[3] = false
                    self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    self.serviceButton.setImage(Asset.icCheckboxGray.image, for: .normal)
                }
                else{ //off -> on
                    self.termsOfUseArray[0] = true
                    self.serviceButton.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    
                    if self.termsOfUseArray.allSatisfy({ $0 == true}) {
                        self.validCheckArray[3] = true
                        self.allAgreeButton.setImage(Asset.icCheckboxBlue.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }
                    else{
                        self.validCheckArray[3] = false
                        self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }

                }
                self.checkAllPass()
            })
            .disposed(by: disposeBag)
        
        seeServiceLabel.rx.tapGesture() //이용약관 내용보기
            .when(.recognized)
            .subscribe(onNext: { _ in
                let vc = SFSafariViewController(url: URL(string: "https://plum-aster-76d.notion.site/69b19922795441cfb18edd49d6f1f265")!)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        privacyButton.rx.tap
            .subscribe({ _ in
                if self.termsOfUseArray[1]{ //on -> off
                    self.termsOfUseArray[1] = false
                    self.validCheckArray[3] = false
                    self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    self.privacyButton.setImage(Asset.icCheckboxGray.image, for: .normal)
                }
                else{ //off -> on
                    self.termsOfUseArray[1] = true
                    self.privacyButton.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    
                    if self.termsOfUseArray.allSatisfy({ $0 == true}){
                        self.validCheckArray[3] = true
                        self.allAgreeButton.setImage(Asset.icCheckboxBlue.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }
                    else{
                        self.validCheckArray[3] = false
                        self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }
                }
                self.checkAllPass()
            })
            .disposed(by: disposeBag)
        
        privacyAgreeTitle.rx.tapGesture()
            .when(.recognized)
            .subscribe({ _ in
                if self.termsOfUseArray[1]{ //on -> off
                    self.termsOfUseArray[1] = false
                    self.validCheckArray[3] = false
                    self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    self.privacyButton.setImage(Asset.icCheckboxGray.image, for: .normal)
                }
                else{ //off -> on
                    self.termsOfUseArray[1] = true
                    self.privacyButton.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    
                    if self.termsOfUseArray.allSatisfy({ $0 == true}){
                        self.validCheckArray[3] = true
                        self.allAgreeButton.setImage(Asset.icCheckboxBlue.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }
                    else{
                        self.validCheckArray[3] = false
                        self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }
                }
                self.checkAllPass()
            })
            .disposed(by: disposeBag)
        
        seePrivacyLabel.rx.tapGesture() //개인정보처리방침 내용보기
            .when(.recognized)
            .subscribe(onNext: { _ in
                let vc = SFSafariViewController(url: URL(string: "https://plum-aster-76d.notion.site/c55286b8e9794522ae05bcc55cdbac13")!)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        year14Button.rx.tap
            .subscribe({ _ in
                if self.termsOfUseArray[2]{ //on -> off
                    self.termsOfUseArray[2] = false
                    self.validCheckArray[3] = false
                    self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    self.year14Button.setImage(Asset.icCheckboxGray.image, for: .normal)
                }
                else{ //off -> on
                    self.termsOfUseArray[2] = true
                    self.year14Button.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    
                    if self.termsOfUseArray.allSatisfy({ $0 == true}) {
                        self.validCheckArray[3] = true
                        self.allAgreeButton.setImage(Asset.icCheckboxBlue.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }
                    else{
                        self.validCheckArray[3] = false
                        self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }
                }
                self.checkAllPass()
            })
            .disposed(by: disposeBag)
        
        year14Label.rx.tapGesture()
            .when(.recognized)
            .subscribe({ _ in
                if self.termsOfUseArray[2]{ //on -> off
                    self.termsOfUseArray[2] = false
                    self.validCheckArray[3] = false
                    self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    self.year14Button.setImage(Asset.icCheckboxGray.image, for: .normal)
                }
                else{ //off -> on
                    self.termsOfUseArray[2] = true
                    self.year14Button.setImage(Asset.icCheckboxBlue.image, for: .normal)
                    
                    if self.termsOfUseArray.allSatisfy({ $0 == true}) {
                        self.validCheckArray[3] = true
                        self.allAgreeButton.setImage(Asset.icCheckboxBlue.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }
                    else{
                        self.validCheckArray[3] = false
                        self.allAgreeButton.setImage(Asset.icCheckboxGray.image, for: .normal) //모두 동의 버튼도 해제해야함
                    }
                }
                self.checkAllPass()
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe({ _ in
                self.signUpDataManager.postCheckEmail(viewController: self, email: self.emailTextField.content!)
            })
            .disposed(by: disposeBag)
        
    }
    
    func checkAllPass(){
        if validCheckArray.allSatisfy({$0}){ //모두 true
            nextButton.setEnable()
        }
        else{
            nextButton.setDisable()
        }
    }
    
    private var scrollView = UIScrollView(frame: .zero).then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var contentView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var navBar = NavBar().then{ make in
        make.leftBtnItem.isHidden = false
    }
    
    private var titleLabel = UILabel().then{ make in
        make.font = .pretendardSemibold20
        make.textColor = .black
        make.text = L10n.SignUp.title
    }
    
    private var guideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.First.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var emailTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Email.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var emailTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Email.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
            //placeholder 색 바꾸기
        make.keyboardType = .emailAddress
    }
    
    private var emailGuideLabel = UILabel().then{ make in
//        make.text = L10n.SignUp.e
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    private var passwordTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Password.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var passwordTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Password.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
            //placeholder 색 바꾸기
        make.isSecureTextEntry = true //비밀번호 *로 표시
        
    }
    
    private var passwordGuideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Password.guidelabel
        make.numberOfLines = 0
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    private var passwordConfirmTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Passwordconfirm.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var passwordConfirmTextField = TextField().then { make in
        make.isSecureTextEntry = true //비밀번호 *로 표시
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Passwordconfirm.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
    }
    
    private var passwordConfirmGuideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Passwordconfirm.guidelabel
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    private var phoneTitleLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Phone.title
    }
    
    private var phoneTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Phone.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
            //placeholder 색 바꾸기
        make.keyboardType = .phonePad
    }
    
    private var phoneButton = ShortButton()
    
    private var phoneGuideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Phone.guidelabel
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    private var authcodeLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Code.title
    }
    
    private var authcodeTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Code.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
        make.keyboardType = .numberPad
    }
    
    private var authTimerLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .primaryBlue
        make.isHidden = true
    }
    
    private var authcodeButton = ShortButton().then { make in
        make.setTitle(L10n.Confirm.Button.title, for: .normal)
    }
    
    private var authGuideLabel = UILabel().then{ make in
        make.font = .pretendardMedium12
        make.textColor = .primaryBlue
        make.text = L10n.SignUp.Code.guidelabel
        make.isHidden = true
    }
    
    private var codeConfirmGuideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Code.guidelabel
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    private var agreeTitleLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Agree.title
    }
    
    private var allAgreeTitle = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Agree.agreall
    }
    
    private var allAgreeButton = UIButton().then{ make in
        make.setImage(Asset.icCheckboxGray.image, for: .normal)
    }
    
    private var serviceAgreeTitle = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.attributedText = NSMutableAttributedString(string: L10n.SignUp.Agree.service)
            .addBlueStringStyleToRange(ranges: [NSRange(location: 13, length: 4)])
    }
    
    private var seeServiceLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Agree.seecontent
        make.attributedText = NSMutableAttributedString(string: L10n.SignUp.Agree.seecontent)
            .style(attrs: [.underlineStyle: 1], range: NSRange(location: 0, length: 4))
        
    }
    
    private var serviceButton = UIButton().then{ make in
        make.setImage(Asset.icCheckboxGray.image, for: .normal)
    }
    
    private var privacyAgreeTitle = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.attributedText = NSMutableAttributedString(string: L10n.SignUp.Agree.privacy)
            .addBlueStringStyleToRange(ranges: [NSRange(location: 16, length: 4)])
    }
    
    private var seePrivacyLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Agree.seecontent
        make.attributedText = NSMutableAttributedString(string: L10n.SignUp.Agree.seecontent)
            .style(attrs: [.underlineStyle: 1], range: NSRange(location: 0, length: 4))
    }
    
    private var privacyButton = UIButton().then{ make in
        make.setImage(Asset.icCheckboxGray.image, for: .normal)
    }
    
    private var year14Label = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Agree.year14
        make.attributedText = NSMutableAttributedString(string: L10n.SignUp.Agree.year14)
            .addBlueStringStyleToRange(ranges: [NSRange(location: 13, length: 4)])
    }
    
    private var year14Button = UIButton().then { make in
        make.setImage(Asset.icCheckboxGray.image, for: .normal)
    }
    
    private var nextButton = LongButton().then { make in
        make.setTitle(L10n.Next.Button.title, for: .normal)
    }
}

// MARK: - Layout

extension SignUpFirstViewController {
    
    private func setupViews() {
        
        view.addSubviews([
            navBar,
            scrollView
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            titleLabel,
            guideLabel,
            emailTitleLabel,
            emailTextField,
            emailGuideLabel,
            passwordTitleLabel,
            passwordTextField,
            passwordGuideLabel,
            passwordConfirmTitleLabel,
            passwordConfirmTextField,
            passwordConfirmGuideLabel,
            phoneTitleLabel,
            phoneTextField,
            phoneGuideLabel,
            phoneButton,
            authcodeLabel,
            authcodeTextField,
            authTimerLabel,
            authGuideLabel,
            authcodeButton,
            codeConfirmGuideLabel,
            agreeTitleLabel,
            allAgreeTitle,
            allAgreeButton,
            serviceAgreeTitle,
            seeServiceLabel,
            serviceButton,
            privacyAgreeTitle,
            seePrivacyLabel,
            privacyButton,
            year14Label,
            year14Button,
            nextButton
        ])
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordConfirmTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        authcodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        phoneTextField.delegate = self
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        contentView.snp.makeConstraints{ make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(39)
            make.leading.equalTo(contentView.snp.leading)
        }
        
        guideLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        emailTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(guideLabel.snp.bottom).offset(45)
            make.leading.equalTo(guideLabel.snp.leading)
        }
        
        emailTextField.snp.makeConstraints{ make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(emailTitleLabel.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        emailGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.leading.equalTo(emailTitleLabel.snp.leading)
        }
        
        passwordTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(emailTextField.snp.bottom).offset(36)
            make.leading.equalTo(guideLabel.snp.leading)
        }
        
        passwordTextField.snp.makeConstraints{ make in
            make.top.equalTo(passwordTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(passwordTitleLabel.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        passwordGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.leading.equalTo(passwordTitleLabel.snp.leading)
            make.trailing.equalTo(passwordTextField.snp.trailing)
        }
        
        passwordConfirmTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(36)
            make.leading.equalTo(guideLabel.snp.leading)
        }
        
        passwordConfirmTextField.snp.makeConstraints{ make in
            make.top.equalTo(passwordConfirmTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(passwordConfirmTitleLabel.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        passwordConfirmGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(4)
            make.leading.equalTo(passwordConfirmTitleLabel.snp.leading)
        }
        
        phoneTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(36)
            make.leading.equalTo(guideLabel.snp.leading)
        }
        
        phoneTextField.snp.makeConstraints{ make in
            make.top.equalTo(phoneTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(phoneTitleLabel.snp.leading)
            make.trailing.equalTo(phoneButton.snp.leading).offset(-14)
        }
        
        phoneGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(4)
            make.leading.equalTo(phoneTitleLabel.snp.leading)
        }
        
        phoneButton.snp.makeConstraints{ make in
            make.centerY.equalTo(phoneTextField.snp.centerY)
            make.width.equalTo(98)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        authcodeLabel.snp.makeConstraints{ make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(36)
            make.leading.equalTo(passwordConfirmTitleLabel.snp.leading)
        }
        
        authcodeTextField.snp.makeConstraints{ make in
            make.top.equalTo(authcodeLabel.snp.bottom).offset(5)
            make.leading.equalTo(authcodeLabel.snp.leading)
            make.trailing.equalTo(authcodeButton.snp.leading).offset(-14)
        }
        
        authcodeButton.snp.makeConstraints{ make in
            make.centerY.equalTo(authcodeTextField.snp.centerY)
            make.width.equalTo(98)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        codeConfirmGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(authcodeTextField.snp.bottom).offset(36)
            make.leading.equalTo(guideLabel.snp.leading)
        }
        
        authTimerLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(authcodeTextField.snp.centerY)
            make.trailing.equalTo(authcodeTextField.snp.trailing).offset(-20)
        }
        
        authGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(authcodeTextField.snp.bottom).offset(5)
            make.leading.equalTo(authcodeTextField.snp.leading)
        }
        
        agreeTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(authcodeTextField.snp.bottom).offset(53)
            make.leading.equalTo(authGuideLabel.snp.leading)
        }
        
        allAgreeButton.snp.makeConstraints{ make in
            make.width.height.equalTo(17)
            make.leading.equalTo(agreeTitleLabel.snp.leading)
            make.top.equalTo(agreeTitleLabel.snp.bottom).offset(13)
        }
        
        allAgreeTitle.snp.makeConstraints{ make in
            make.leading.equalTo(allAgreeButton.snp.trailing).offset(15)
            make.centerY.equalTo(allAgreeButton.snp.centerY)
        }
        
        serviceButton.snp.makeConstraints{ make in
            make.width.height.equalTo(17)
            make.leading.equalTo(allAgreeButton.snp.leading)
            make.top.equalTo(allAgreeTitle.snp.bottom).offset(13)
        }
        
        serviceAgreeTitle.snp.makeConstraints{ make in
            make.leading.equalTo(serviceButton.snp.trailing).offset(15)
            make.centerY.equalTo(serviceButton.snp.centerY)
        }
        
        seeServiceLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(serviceAgreeTitle)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        privacyButton.snp.makeConstraints{ make in
            make.width.height.equalTo(17)
            make.leading.equalTo(agreeTitleLabel.snp.leading)
            make.top.equalTo(serviceButton.snp.bottom).offset(13)
        }
        
        privacyAgreeTitle.snp.makeConstraints{ make in
            make.leading.equalTo(privacyButton.snp.trailing).offset(15)
            make.centerY.equalTo(privacyButton.snp.centerY)
        }
        
        seePrivacyLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(privacyAgreeTitle)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        year14Label.snp.makeConstraints{ make in
            make.leading.equalTo(year14Button.snp.trailing).offset(15)
            make.centerY.equalTo(year14Button.snp.centerY)
        }
        
        year14Button.snp.makeConstraints{ make in
            make.width.height.equalTo(17)
            make.leading.equalTo(agreeTitleLabel.snp.leading)
            make.top.equalTo(privacyButton.snp.bottom).offset(13)
        }
        
        nextButton.snp.makeConstraints{ make in
            make.top.equalTo(year14Label.snp.bottom).offset(57)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -42 : -22)
        }
    }
}

extension SignUpFirstViewController {
    func didSuccessCheckEmail(code:Int){
        if code == 1000{
            self.emailGuideLabel.isHidden = true
            UserInfo.shared.email = self.emailTextField.text!
            UserInfo.shared.password = self.passwordTextField.text!
            UserInfo.shared.phoneNumber = self.phoneTextField.text!
            self.viewModel.inputs.tapNext.onNext(())
        }
        else if code == 2012 {
            self.emailGuideLabel.isHidden = false
            self.emailGuideLabel.text = L10n.SignUp.Email.Guidelabel.exist
            validCheckArray[0] = false
            nextButton.setDisable()
            AppContext.shared.makeToast("이미 존재하는 이메일입니다. 다른 이메일을 입력해주세요.")
        }
    }
    
    func didSuccessCheckPhone(code:Int){
        if code == 1000{ //중복 x
            self.phoneGuideLabel.isHidden = true

            //인증코드 타이머
            self.authTimer?.invalidate()
            
            self.authTime = 180
            self.authTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.authtimerCallback), userInfo: nil, repeats: true)
            
            //재인증 시 초기 세팅하기 위해 한번 더 설정하는 부분
            self.validCheckArray[2] = false //재인증할 수 있으므로 일단 false로 설정
            
            self.phoneButton.setTitle(L10n.SignUp.Phone.resendCode, for: .normal)
            self.phoneNumber = "+82\(self.phoneTextField.text!.replacingOccurrences(of: "-", with: "").suffix(10))"
            print(self.phoneNumber)
            
            
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(self.phoneNumber, uiDelegate: nil) { verificationID, error in
                  if let error = error {
                      AppContext.shared.makeToast("인증번호 전송에 실패하였습니다. 다시 시도해주세요.")
                      print(error)
                    return
                  }
                  // 에러가 없다면 사용자에게 인증코드와 verificationID(인증ID) 전달, 전송버튼 활성화
                    self.verificationId = verificationID!
                    self.phoneButton.setEnable()
                    self.phoneButton.setTitle(L10n.SignUp.Phone.resendCode, for: .normal)
              }
        }
        else if code == 2022 { //중복 o
            self.phoneGuideLabel.isHidden = false
            validCheckArray[2] = false
            
            self.phoneButton.setDisable()
        }
    }
    
    func failedToRequest(message: String) {
        AppContext.shared.makeToast(message)
    }
}

extension SignUpFirstViewController: UITextFieldDelegate {
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
        if (textFieldText.replacingOccurrences(of: "-", with: "").count) < 11 { //'-' 제외하고 11자리 미만일때 인증문자 발송 버튼 비활성화
            phoneButton.setDisable()
        }
        else{
            phoneButton.setEnable()
        }
        
        phoneButton.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)
        
        return false
    }
}
