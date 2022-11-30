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

final class FindEmailorPasswordViewController: BaseViewController {
    
    var phoneNumber = ""
    var verificationId = ""
    
    var authTime = 180 //3분
    var authTimer: Timer?
    
    var sendCodebuttonTime = 2 //2초
    var sendCodeButtonTimer: Timer?
    
    var email = ""
    
    //하단 버튼 액션을 분기별로 처리하기 위함
    //순서대로 이메일찾기, 로그인화면 이동(이메일), 비밀번호 찾기, 로그인 화면 이동(비밀번호) -> 초기에는 이메일찾기이므로 1
    var buttonAction = [true, false, false, false]
    
    lazy var dataManager = FindDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initialLayout()

        viewModelInput()
//        viewModelOutput()
        
        findEmailphoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        findEmailauthcodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
    
        if textField == findEmailphoneTextField {
            var textFieldText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if (textFieldText.replacingOccurrences(of: "-", with: "").count) < 11 { //'-' 제외하고 11자리 미만일때
                findEmailphoneButton.setDisable()
                if (textFieldText.count == 4){
                    textField.text?.insert("-", at: textFieldText.index(textFieldText.startIndex, offsetBy: 3))
                }
                else if (textFieldText.count == 9){
                    textField.text?.insert("-", at: textFieldText.index(textFieldText.startIndex, offsetBy: 8))
                }
            }
            else{
                findEmailphoneButton.setEnable()
            }
        }
        else if textField == findEmailauthcodeTextField {
            if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 6{
                findEmailauthcodeButton.setEnable()
            }
            else{
                findEmailauthcodeButton.setDisable()
            }
        }
    }
    
    @objc func authtimerCallback() {
        findEmailauthTimerLabel.isHidden = false
        authTime -= 1
        findEmailauthTimerLabel.text = "\(Int((authTime / 60) % 60)):\(String(format:"%0d", Int(authTime % 60)))"
        
        if (authTime == 0){
            authTimer?.invalidate()
            findEmailauthcodeButton.setDisable()
        }
    }
    
    @objc func sendCodeTimerCallback() {
        sendCodebuttonTime -= 1
        
        if (sendCodebuttonTime == 0){
            sendCodeButtonTimer?.invalidate()
            findEmailphoneButton.setEnable()
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
                
                buttonAction = [true, false, false, false]
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
                
                buttonAction = [false, false, true, false]
            })
            .disposed(by: disposeBag)
        
        findEmailphoneButton.rx.tapGesture()
            .when(.recognized)
            .subscribe({ _ in
                //버튼 연타 방지
                self.findEmailphoneButton.setDisable()
                
                //휴대폰번호 중복 체크
                self.dataManager.postFindEmail(viewController: self, phoneNumber: (self.findEmailphoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
                
            })
        
        findEmailauthcodeButton.rx.tapGesture()
            .when(.recognized)
            .subscribe({ _ in
                
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationId,
                                                                         verificationCode: self.findEmailauthcodeTextField.text!)
                
                Auth.auth().signIn(with: credential) { (authData, error) in
                    if error != nil {
                        print("로그인 Error: \(error.debugDescription)")
                        self.findEmailauthGuideLabel.isHidden = false
                        return
                    }
                    self.findEmailauthGuideLabel.isHidden = true //안내문구, 시간 모두 없애기
                    self.findEmailauthTimerLabel.isHidden = true
                    self.authTimer?.invalidate()
                    
                    print("인증성공 : \(authData)")
                    
                    self.findTitle.text = L10n.Find.Email.Find.title
                    self.emailFindView.isHidden = true
                    self.emailFoundView.isHidden = false
                    
                    self.foundemailTextField.text = self.email
                    
                    self.bottomButton.setTitle(L10n.Confirm.Button.title, for: .normal)
                    
                    self.buttonAction[0] = false
                    self.buttonAction[1] = true
                    
                    self.bottomButton.setEnable()
                }
            })
        
        bottomButton.rx.tapGesture()
            .when(.recognized)
            .subscribe({ _ in
                if self.buttonAction[0] {
                    self.dataManager.postFindEmail(viewController:self, phoneNumber: self.findEmailphoneTextField.text!)
                }
                else if self.buttonAction[1]{
                    self.viewModel.inputs.login.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
//
//    private func viewModelOutput() {
//        postCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
//
//        let dataSource = RxCollectionViewSectionedReloadDataSource<BasicPostSection> {
//            [weak self] _, collectionView, indexPath, item in
//
//                guard let self = self,
//                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicPostCell.id, for: indexPath) as? BasicPostCell
//                else { return UICollectionViewCell() }
//
//                cell.postInfoView.bookMarkIcon.rx.tap
//                    .map { indexPath.row }
//                    .subscribe(onNext: { [weak self] idx in
//                        self?.viewModel.inputs.tapPostBookMark.onNext(idx)
//                    })
//                    .disposed(by: cell.disposeBag)
//
//                cell.configure(with: item)
//                return cell
//        }
//
//        viewModel.outputs.posts
//            .do(onNext: { [weak self] configs in
//                self?.numPostLabel.text = "총 \(configs.count) 건" // 태그에 따라서 총 찜한 목록의 게시글이 바뀜
//
//                if configs.isEmpty {
//                    self?.emptyLabel.isHidden = false
//                    switch self?.runningTagInt {
//                    case 0:
//                        self?.emptyLabel.text = L10n.BookMark.Main.Empty.Before.title
//                    case 1:
//                        self?.emptyLabel.text = L10n.BookMark.Main.Empty.After.title
//                    default:
//                        self?.emptyLabel.text = L10n.BookMark.Main.Empty.Holiday.title
//                    }
//                } else {
//                    self?.emptyLabel.isHidden = true
//                }
//            })
//            .map { [BasicPostSection(items: $0)] }
//            .bind(to: postCollectionView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
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
        make.font = .pretendardMedium14
        make.textColor = .primaryBlue
        make.text = L10n.SignUp.Code.guidelabel
        make.isHidden = true
    }
    
    private var findEmailcodeConfirmGuideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Code.guidelabel
        make.textColor = .primaryBlue
        make.font = .pretendardMedium14
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
            make.height.equalTo(300)
        }
        view.isHidden = true
    }
    
    private var findpasswordemailLabel = UILabel().then{ make in
        make.font = .pretendardMedium14
        make.textColor = .black
        make.text = L10n.SignUp.Code.title
    }
    
    private var findpasswordemailTextField = TextField().then { make in
        make.attributedPlaceholder = NSAttributedString(string: L10n.SignUp.Code.placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray61])
        make.keyboardType = .numberPad
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
        make.font = .pretendardMedium14
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
        make.font = .pretendardMedium14
        make.isHidden = true
    }
    
    private var findpasswordConfirmTitleLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Passwordconfirm.title
        make.textColor = .black
        make.font = .pretendardMedium14
    }
    
    private var passwordConfirmTextField = TextField().then { make in
        make.isSecureTextEntry = true //비밀번호 *로 표시
        
    }
    
    private var findpasswordConfirmGuideLabel = UILabel().then{ make in
        make.text = L10n.SignUp.Passwordconfirm.guidelabel
        make.textColor = .primaryBlue
        make.font = .pretendardMedium14
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
        
        bottomButton.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom).offset(-42)
        }
        
    }
}

extension FindEmailorPasswordViewController {
    
    func didSuccessFindEmail(response: PostFindEmailResponse){
        switch response.code {
        case 1000:
            
            self.findEmailphoneGuideLabel.isHidden = true
            email = response.result!.email

            //인증코드 타이머
            self.authTime = 180
            self.authTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.authtimerCallback), userInfo: nil, repeats: true)
            
            self.findEmailphoneButton.setTitle(L10n.SignUp.Phone.resendCode, for: .normal)
            self.phoneNumber = "+82\(self.findEmailphoneTextField.text!.replacingOccurrences(of: "-", with: "").suffix(10))"
            print(self.phoneNumber)
            
            
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(self.phoneNumber, uiDelegate: nil) { verificationID, error in
                  if let error = error {
                      AppContext.shared.makeToast("에러가 발생했습니다. 다시 시도해주세요")
                      print(error)
                    return
                  }
                  // 에러가 없다면 사용자에게 인증코드와 verificationID(인증ID) 전달
                    self.verificationId = verificationID!
              }
            break
            
        case 2013:
            self.findEmailphoneButton.setDisable()
            findEmailphoneGuideLabel.isHidden = false
        default:
            break
        }
    }

    func failedToRequest(message: String) {
        
        AppContext.shared.makeToast(message)
    }
}
