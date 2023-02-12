//
//  EditPasswordViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/13.
//

import RxCocoa
import RxGesture
import RxSwift
import Then
import UIKit
import SnapKit
import FirebaseAuth
import AnyFormatKit

class EditPasswordViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initialLayout()
        
        viewModelInput()
        viewModelOutput()
        
        //실시간으로 textfield 입력하는 부분 이벤트 받아서 처리 for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordConfirmTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    init(viewModel: EditPasswordViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == passwordTextField {
            if !Regex().isValidPassword(input: passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? " "){
                passwordGuideLabel.isHidden = false
            }
            else{
                passwordGuideLabel.isHidden = true
            }
            
            //비밀번호 입력창에서도 비밀번호 확인 입력창과 일치하는지 검증해야함
            if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? " " != passwordConfirmTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? " " && !(passwordConfirmTextField.text ?? "").isEmpty {
                passwordConfirmGuideLabel.isHidden = false
                
                confirmButton.setDisable()
            }
            else{
                passwordConfirmGuideLabel.isHidden = true
            }
        }
        else if textField == passwordConfirmTextField {
            if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? " " != passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? " " {
                passwordConfirmGuideLabel.isHidden = false
            }
            else{
                passwordConfirmGuideLabel.isHidden = true
            }
        }
    }
    
    
    private var viewModel: EditPasswordViewModel
    
    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .subscribe({ _ in
                //                self.signUpDataManager.postCheckEmail(viewController: self, email: (self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func viewModelOutput() {

        
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
        make.titleLabel.isHidden = false
        make.titleLabel.text = L10n.MyPage.List.editPassword
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
    
    private var confirmButton = LongButton().then { make in
        make.setTitle(L10n.Next.Button.title, for: .normal)
        make.setDisable()
    }
}


// MARK: - Layout

extension EditPasswordViewController {
    
    private func setupViews() {
        
        view.addSubviews([
            navBar,
            passwordTitleLabel,
            passwordTextField,
            passwordGuideLabel,
            passwordConfirmTitleLabel,
            passwordConfirmTextField,
            passwordConfirmGuideLabel,
            confirmButton
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        passwordTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(navBar.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(28)
        }
        
        passwordTextField.snp.makeConstraints{ make in
            make.top.equalTo(passwordTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(passwordTitleLabel.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        passwordGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.leading.equalTo(passwordTitleLabel.snp.leading)
            make.trailing.equalTo(passwordTextField.snp.trailing)
        }
        
        passwordConfirmTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(36)
            make.leading.equalTo(passwordTitleLabel.snp.leading)
        }
        
        passwordConfirmTextField.snp.makeConstraints{ make in
            make.top.equalTo(passwordConfirmTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(passwordConfirmTitleLabel.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        passwordConfirmGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(4)
            make.leading.equalTo(passwordConfirmTitleLabel.snp.leading)
        }
        
        confirmButton.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -42 : -22)
        }
    }
}
