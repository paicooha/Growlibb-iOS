//
//  EditPasswordFirstViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/15.
//

import RxCocoa
import RxGesture
import RxSwift
import Then
import UIKit
import SnapKit
import FirebaseAuth
import AnyFormatKit

final class EditPasswordFirstViewController: BaseViewController {
        
    var phoneNumber = ""
    var verificationId = ""
    
    var authTime = 180 //3분
    var authTimer: Timer?

    //아이디, 인증번호를 모두 했는지 확인하기 위한 배열
    var validCheckArray = [false, false]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initialLayout()
        
        viewModelInput()
        viewModelOutput()
        
        //실시간으로 textfield 입력하는 부분 이벤트 받아서 처리
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        authcodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        phoneTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) { //다시 돌아올때 인증번호 초기화
        authTime = 180
        validCheckArray[1] = false
        
        authcodeTextField.text = ""
        authGuideLabel.isHidden = true
        
        if (phoneTextField.text ?? "").isEmpty { //2번째 화면에서 인증했다가 다시 돌아온 상황이 아니라면 disable 상태
            phoneButton.setDisable()
        }
        phoneButton.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)
        
        authcodeButton.setDisable()
        nextButton.setDisable()
    }
    
    init(viewModel: EditPasswordFirstViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == emailTextField {
            if !Regex().isValidEmail(input: emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? " "){
                emailGuideLabel.isHidden = false
                emailGuideLabel.text = L10n.SignUp.Email.Guidelabel.notemail
                validCheckArray[0] = false
                
                nextButton.setDisable() //후에 다시수정할 수 있으므로
            }
            else{ //이메일 도메인 길이 체크
                if ((emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "@").first?.count)! > 64) || ((emailTextField.text?.components(separatedBy: "@")[1].count)! > 255){
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
        else if textField == authcodeTextField {
            checkMaxLength(textField: textField, maxLength: 6)
            
            if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 6{
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


    private var viewModel: EditPasswordFirstViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)
        
        phoneButton.rx.tap
            .subscribe({ _ in
                //버튼 연타 방지 -> 인증번호 콜백시 활성화하도록 수정
                self.phoneButton.setDisable()
                self.authGuideLabel.isHidden = true
                self.phoneGuideLabel.isHidden = true

                //인증코드 타이머
                self.authTimer?.invalidate()
                
                self.authTime = 180
                self.authTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.authtimerCallback), userInfo: nil, repeats: true)
                
                //재인증 시 초기 세팅하기 위해 한번 더 설정하는 부분
                self.validCheckArray[1] = false //재인증할 수 있으므로 일단 false로 설정
                
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
                    
                    self.validCheckArray[1] = true

                    print("인증성공 : \(authData)")
                    self.checkAllPass()
                }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe({ _ in
                let postCheckPasswordRequest = PostCheckPasswordRequest(phoneNumber: self.phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), email: self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                UserInfo.shared.phoneNumber = postCheckPasswordRequest.phoneNumber
                UserInfo.shared.email =
                postCheckPasswordRequest.email
                self.viewModel.inputs.checkpassword.onNext(postCheckPasswordRequest)
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

    private func viewModelOutput() {

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }
    
    private var navBar = NavBar().then{ make in
        make.leftBtnItem.isHidden = false
        make.titleLabel.text = L10n.MyPage.List.editPassword
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
    
    private var nextButton = LongButton().then { make in
        make.setTitle(L10n.Next.Button.title, for: .normal)
    }
}

// MARK: - Layout

extension EditPasswordFirstViewController {
    
    private func setupViews() {
        
        view.addSubviews([
            navBar,
            emailTitleLabel,
            emailTextField,
            emailGuideLabel,

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
            nextButton
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        emailTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(navBar.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(28)
        }
        
        emailTextField.snp.makeConstraints{ make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(emailTitleLabel.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        emailGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.leading.equalTo(emailTitleLabel.snp.leading)
        }
        
        phoneTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(emailTextField.snp.bottom).offset(36)
            make.leading.equalTo(emailTitleLabel.snp.leading)
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
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        authcodeLabel.snp.makeConstraints{ make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(36)
            make.leading.equalTo(phoneTitleLabel.snp.leading)
        }
        
        authcodeTextField.snp.makeConstraints{ make in
            make.top.equalTo(authcodeLabel.snp.bottom).offset(5)
            make.leading.equalTo(authcodeLabel.snp.leading)
            make.trailing.equalTo(authcodeButton.snp.leading).offset(-14)
        }
        
        authcodeButton.snp.makeConstraints{ make in
            make.centerY.equalTo(authcodeTextField.snp.centerY)
            make.width.equalTo(98)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        codeConfirmGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(authcodeTextField.snp.bottom).offset(36)
            make.leading.equalTo(authcodeLabel.snp.leading)
        }
        
        authTimerLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(authcodeTextField.snp.centerY)
            make.trailing.equalTo(authcodeTextField.snp.trailing).offset(-20)
        }
        
        authGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(authcodeTextField.snp.bottom).offset(5)
            make.leading.equalTo(authcodeTextField.snp.leading)
        }
        
        nextButton.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -42 : -22)
        }
    }
}

extension EditPasswordFirstViewController: UITextFieldDelegate {
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
        
        let textFieldText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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
