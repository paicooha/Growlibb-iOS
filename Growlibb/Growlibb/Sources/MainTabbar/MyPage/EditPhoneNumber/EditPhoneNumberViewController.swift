//
//  EditPhoneNumberViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
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

final class EditPhoneNumberViewController: BaseViewController {
    
    var phoneNumber = ""
    var verificationId = ""
    
    var authTime = 180 //3분
    var authTimer: Timer?
    
    var email = ""
    var userInfo = UserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        
        authcodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        phoneTextField.delegate = self
    }

    init(viewModel: EditPhoneNumberViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
    
        if textField == authcodeTextField {
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
            
            self.verificationId = "" //3분 지났을 시 인증번호 무효화
        }
    }

    private var viewModel: EditPhoneNumberViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)
        
        phoneButton.rx.tap
            .subscribe({ _ in
                //버튼 연타 방지
                self.phoneButton.setDisable()
                //휴대폰번호 중복 체크
//                self.dataManager.postFindEmail(viewController: self, phoneNumber: (self.findEmailphoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
                
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
//                    self.findEmailauthGuideLabel.isHidden = true //안내문구, 시간 모두 없애기
                    self.authGuideLabel.text = L10n.SignUp.Code.Correct.guidelabel
                    self.authTimerLabel.isHidden = true
                    self.authTimer?.invalidate()
                    
                    print("인증성공 : \(authData)")
                    
                    self.bottomButton.setEnable()
                }
            })
            .disposed(by: disposeBag)

        bottomButton.rx.tap
            .subscribe({ [self] _ in

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

    private var navBar = NavBar().then{ make in
        make.leftBtnItem.isHidden = false
        make.titleLabel.text = L10n.MyPage.List.editPhone
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
    
    private var phoneButton = ShortButton().then { make in
        make.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)
        make.setDisable()
    }
    
    private var phoneGuideLabel = UILabel().then{ make in
        make.font = .pretendardMedium12
        make.textColor = .primaryBlue
        make.text = L10n.Find.Email.Notfind.guidelabel
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
        make.setDisable()
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
    
    private var bottomButton = LongButton().then { make in
        make.setTitle(L10n.Modify.title, for: .normal)
        make.setDisable()
    }
}

// MARK: - Layout

extension EditPhoneNumberViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            phoneTitleLabel,
            phoneTextField,
            phoneButton,
            phoneGuideLabel,
            authcodeLabel,
            authcodeTextField,
            authcodeButton,
            authTimerLabel,
            authGuideLabel,
            bottomButton
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        phoneTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(navBar.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(28)
        }
        
        phoneTextField.snp.makeConstraints{ make in
            make.top.equalTo(phoneTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(phoneTitleLabel.snp.leading)
            make.trailing.equalTo(phoneButton.snp.leading).offset(-14)
        }
        
        phoneButton.snp.makeConstraints{ make in
            make.centerY.equalTo(phoneTextField.snp.centerY)
            make.width.equalTo(98)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        phoneGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(4)
            make.leading.equalTo(phoneTextField.snp.leading)
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
        
        authTimerLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(authcodeTextField.snp.centerY)
            make.trailing.equalTo(authcodeTextField.snp.trailing).offset(-20)
        }
        
        authGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(authcodeTextField.snp.bottom).offset(5)
            make.leading.equalTo(authcodeTextField.snp.leading)
        }
        
        bottomButton.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -42 : -22)
        }
        
    }
}

extension EditPhoneNumberViewController: UITextFieldDelegate{
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
        if (textFieldText.replacingOccurrences(of: "-", with: "").count) < 11 { //'-' 제외하고 11자리 미만일때
            phoneButton.setDisable()
            phoneButton.setTitle(L10n.SignUp.Phone.sendCode, for: .normal)

            bottomButton.setDisable()
        }
        else{
            phoneButton.setEnable()
        }
        
        return false
    }
}
