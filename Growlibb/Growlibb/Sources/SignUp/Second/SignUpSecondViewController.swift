//
//  SignUpSecondViewController.swift
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
import DropDown
import FirebaseMessaging
import AnyFormatKit

final class SignUpSecondViewController: BaseViewController {
    
    let jobList = [L10n.Job.it, L10n.Job.man, L10n.Job.pub, L10n.Job.off, L10n.Job.res, L10n.Job.arc, L10n.Job.med,
                   L10n.Job.hel, L10n.Job.pla, L10n.Job.des,
                   L10n.Job.sel, L10n.Job.hou, L10n.Job.stu, L10n.Job.etc, L10n.Job.not]
    lazy var signUpDataManager = SignUpDataManager()
    private var userKeyChainService: UserKeychainService
    private var loginKeyChainService: LoginKeyChainService
    
    //닉네임 중복확인 여부 -> v230322 (성별, 생년월일, 직업 선택으로 바뀜)
    var validCheck = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initialLayout()
        
        setDropdown()

        viewModelInput()
//        viewModelOutput()
        
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        birthTextField.delegate = self
    }

    init(viewModel: SignUpSecondViewModel, userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared, loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        self.viewModel = viewModel
        self.userKeyChainService = userKeyChainService
        self.loginKeyChainService = loginKeyChainService
        
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkAllPass(){
        if validCheck { //모두 true
            nextButton.setEnable()
        }
        else{
            nextButton.setDisable()
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        validCheck = false
        nicknameGuideLabel.isHidden = true
        
        if nicknameTextField.text?.count ?? 0 >= 1 {
            nicknameButton.setEnable()
            checkMaxLength(textField: textField, maxLength: 10)
        }
        else{
            nicknameButton.setDisable()
        }
        nextButton.setDisable()
    }
    
    private var viewModel: SignUpSecondViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBag)
        
        nicknameButton.rx.tap
            .subscribe({ _ in
                self.signUpDataManager.postCheckNickname(viewController: self, nickname: self.nicknameTextField.text!)
            })
            .disposed(by: disposeBag)
        
        jobSelectButton.rx.tap
            .subscribe({ _ in
                self.dropDown.show()
                self.dropdownImageView.image = Asset.icDropdownUp.image
            })
            .disposed(by: disposeBag)
        
        manButton.rx.tap
            .subscribe({ _ in
                if UserInfo.shared.gender == "M" {
                    UserInfo.shared.gender = ""
                    self.manButton.setGrayButton()
                } else {
                    UserInfo.shared.gender = "M"
                    self.manButton.setBlueButton()
                    self.womanButton.setGrayButton()
                }
            })
            .disposed(by: disposeBag)
        
        womanButton.rx.tap
            .subscribe({ _ in
                if UserInfo.shared.gender == "F" {
                    UserInfo.shared.gender = ""
                    self.womanButton.setGrayButton()
                } else {
                    UserInfo.shared.gender = "F"
                    self.womanButton.setBlueButton()
                    self.manButton.setGrayButton()
                }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe({ _ in
                UserInfo.shared.nickName = self.nicknameTextField.text!
                UserInfo.shared.birthday = self.birthTextField.text ?? nil
                if let token = Messaging.messaging().fcmToken {
                    UserInfo.shared.fcmToken = token
                }
                self.signUpDataManager.postSignUp(viewController: self)
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
    
    private var scrollView = UIScrollView().then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = false
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
        make.text = L10n.SignUp.Second.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }

    private var nicknameTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Nickname.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }

    private var nicknameTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Nickname.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
            //placeholder 색 바꾸기
    }

    private var nicknameButton = ShortButton().then { make in
        make.setTitle(L10n.SignUp.Nickname.checkDuplicate, for: .normal)
        make.setDisable()
    }
    
    private var nicknameGuideLabel = UILabel().then{ make in
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    private var genderTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Gender.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var manButton = ShortButton().then { make in
        make.setTitle(L10n.SignUp.Gender.man, for: .normal)
        make.setGrayButton()
    }
    
    private var womanButton = ShortButton().then { make in
        make.setTitle(L10n.SignUp.Gender.woman, for: .normal)
        make.setGrayButton()
    }
    
    private var birthTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Birth.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var birthTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Birth.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
            //placeholder 색 바꾸기
        make.keyboardType = .numberPad
    }
    
    private var birthGuideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Birth.guidelabel
        make.textColor = .primaryBlue
        make.font = .pretendardMedium12
        make.isHidden = true
    }
    
    private var jobTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Job.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var jobSelectButton = UIButton().then { make in
        make.setTitle(L10n.SignUp.Job.placeholder, for: .normal)
        make.setTitleColor(.gray61, for: .normal)
        make.titleLabel?.font = .pretendardMedium14
        make.contentHorizontalAlignment = .left
        make.titleEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0)
        
        make.backgroundColor = .veryLightGray
        make.clipsToBounds = true
        make.layer.cornerRadius = 12
    }
    
    private var dropDown = DropDown()
    
    private var dropdownImageView = UIImageView().then { make in
        make.image = Asset.icDropdownDown.image
    }
    
    private var nextButton = LongButton().then { make in
        make.setTitle(L10n.Next.Button.title, for: .normal)
        make.setDisable()
    }
    
    private func setDropdown(){
        //dropdown ui
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor.black // 선택된 아이템 텍스트 색상
        DropDown.appearance().setupCornerRadius(12)
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().selectionBackgroundColor = .white
        
        dropDown.dismissMode = .automatic // 팝업을 닫을 모드 설정
        
        //dropdown 기능
        dropDown.dataSource = jobList //아이템 리스트
        dropDown.anchorView = jobSelectButton //드롭다운이 펼쳐질 축이 되는 UI
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.textFont = .pretendardMedium14
        
        // Item 선택 시 처리
        dropDown.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self?.jobSelectButton.setTitle(item, for: .normal)
            self?.jobSelectButton.setTitleColor(.black, for: .normal)
            
            self?.dropdownImageView.image = Asset.icDropdownDown.image
            
            UserInfo.shared.job = item
        }
        
        // 취소 시 처리
        dropDown.cancelAction = { [weak self] in
            //빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
            self?.dropdownImageView.image = Asset.icDropdownDown.image
        }
    }
}

// MARK: - Layout

extension SignUpSecondViewController {
    
    private func setupViews() {
        
        view.addSubviews([
            navBar,
            scrollView
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            titleLabel,
            guideLabel,
            nicknameTitleLabel,
            nicknameGuideLabel,
            nicknameTextField,
            nicknameButton,
            genderTitleLabel,
            manButton,
            womanButton,
            birthTitleLabel,
            birthTextField,
            birthGuideLabel,
            jobTitleLabel,
            jobSelectButton,
            dropdownImageView,
            nextButton
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
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(39)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        guideLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        nicknameTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(guideLabel.snp.bottom).offset(45)
            make.leading.equalTo(guideLabel.snp.leading)
        }
        
        nicknameTextField.snp.makeConstraints{ make in
            make.top.equalTo(nicknameTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameTitleLabel.snp.leading)
            make.trailing.equalTo(nicknameButton.snp.leading).offset(-14)
        }
        
        nicknameGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(4)
            make.leading.equalTo(nicknameTextField.snp.leading)
        }
        
        nicknameButton.snp.makeConstraints{ make in
            make.centerY.equalTo(nicknameTextField.snp.centerY)
            make.width.equalTo(98)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
        }
        
        genderTitleLabel.snp.makeConstraints{ make in
            make.leading.equalTo(nicknameTitleLabel.snp.leading)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(36)
        }
        
        manButton.snp.makeConstraints{ make in
            make.leading.equalTo(genderTitleLabel.snp.leading)
            make.top.equalTo(genderTitleLabel.snp.bottom).offset(5)
            make.trailing.equalTo(contentView.snp.centerX).offset(-6)
        }
        
        womanButton.snp.makeConstraints{ make in
            make.centerY.equalTo(manButton.snp.centerY)
            make.leading.equalTo(contentView.snp.centerX).offset(6)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
        }
        
        birthTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(manButton.snp.bottom).offset(36)
            make.leading.equalTo(manButton.snp.leading)
        }
        
        birthTextField.snp.makeConstraints{ make in
            make.top.equalTo(birthTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(birthTitleLabel.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
        }
        
        birthGuideLabel.snp.makeConstraints{ make in
            make.top.equalTo(birthTextField.snp.bottom).offset(5)
            make.leading.equalTo(birthTextField.snp.leading)
        }
        
        jobTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(birthTextField.snp.bottom).offset(36)
            make.leading.equalTo(birthTextField.snp.leading)
        }
        
        jobSelectButton.snp.makeConstraints{ make in
            make.top.equalTo(jobTitleLabel.snp.bottom).offset(5)
            make.height.equalTo(57)
            make.leading.equalTo(jobTitleLabel.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
        }
        
        dropdownImageView.snp.makeConstraints { make in
            make.centerY.equalTo(jobSelectButton.snp.centerY)
            make.trailing.equalTo(jobSelectButton.snp.trailing).offset(-28)
        }
        
        nextButton.snp.makeConstraints{ make in
            make.top.equalTo(jobSelectButton.snp.bottom).offset(56)
            make.leading.equalTo(contentView.snp.leading).offset(28)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.bottom.equalTo(contentView.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -42 : -22)
        }

    }
}

extension SignUpSecondViewController {
    func didSuccessCheckNickname(code:Int){
        if code == 1000{
            validCheck = true
            self.nicknameGuideLabel.isHidden = false
            self.nicknameGuideLabel.text = L10n.SignUp.Nickname.Guidelabel.valid
            checkAllPass()
        }
        else if code == 2023 {
            validCheck = false
            self.nicknameGuideLabel.isHidden = false
            self.nicknameGuideLabel.text = L10n.SignUp.Nickname.Guidelabel.exist
        }
    }
    
    func didSuccessSignUp(result: PostSignUpResult){
        self.loginKeyChainService.setLoginInfo(loginType: LoginType.member, userID: result.userID, token: LoginToken(jwt: result.jwt))
        self.userKeyChainService.nickName = result.nickname
        self.userKeyChainService.fcmToken = Messaging.messaging().fcmToken ?? ""
        
        self.viewModel.inputs.tapNext.onNext(())
    }
    
    func failedToRequest(message: String) {
        AppContext.shared.makeToast(message)
    }
}

extension SignUpSecondViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkMaxLength(textField: textField, maxLength: 10) // '-' 포함해서 10자리로 제한
        
        guard let text = textField.text else {
            return false
        }
        let characterSet = CharacterSet(charactersIn: string)
        if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
            return false
        }
        
        let formatter = DefaultTextInputFormatter(textPattern: "####-##-##") //포맷 제한
        let result = formatter.formatInput(currentText: text, range: range, replacementString: string)
        textField.text = result.formattedText
        let position = textField.position(from: textField.beginningOfDocument, offset: result.caretBeginOffset)!
        textField.selectedTextRange = textField.textRange(from: position, to: position)
        
        let textFieldText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if textFieldText.count == 10 && Regex().isValidBirthday(input: textFieldText.replacingOccurrences(of: "-", with: "")) {
            self.validCheck = true
            birthGuideLabel.isHidden = true
        }
        else if !textFieldText.isEmpty && !Regex().isValidBirthday(input: textFieldText.replacingOccurrences(of: "-", with: "")) {
            self.validCheck = false
            birthGuideLabel.isHidden = false
        } else if textFieldText.isEmpty {
            self.validCheck = true //생년월일 정보를 지우고싶을 수 있으므로
            birthGuideLabel.isHidden = true
        }
        checkAllPass()
        
        return false
    }
}
