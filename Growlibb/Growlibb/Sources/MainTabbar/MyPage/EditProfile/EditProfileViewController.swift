//
//  EditProfileViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/12.
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

final class EditProfileViewController: BaseViewController {
    
    let jobList = [L10n.Job.it, L10n.Job.man, L10n.Job.pub, L10n.Job.off, L10n.Job.res, L10n.Job.arc, L10n.Job.med,
                   L10n.Job.hel, L10n.Job.pla, L10n.Job.des,
                   L10n.Job.sel, L10n.Job.hou, L10n.Job.stu, L10n.Job.etc, L10n.Job.not]
    private var userKeyChainService: UserKeychainService
    private var loginKeyChainService: LoginKeyChainService
    
    //닉네임 중복확인, 생년월일, 직업 체크여부를 확인하기 위한 배열
    var validCheckArray = [false, false, false]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initialLayout()
        
        setDropdown()

        viewModelInput()
        viewModelOutput()
        
//        nicknameTextField.delegate = self
        //실시간으로 textfield 입력하는 부분 이벤트 받아서 처리
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        birthTextField.delegate = self
    }

    init(viewModel: EditProfileViewModel, userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared, loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
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
        if validCheckArray.allSatisfy({$0}){ //모두 true
            confirmButton.setEnable()
        }
        else{
            print(validCheckArray)
            confirmButton.setDisable()
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        validCheckArray[0] = false
        nicknameGuideLabel.isHidden = true
        
        if nicknameTextField.text?.count ?? 0 >= 1 {
            confirmButton.setEnable()
            checkMaxLength(textField: textField, maxLength: 10)
        }
        else{
            confirmButton.setDisable()
        }
        confirmButton.setDisable()
    }
    
    private var viewModel: EditProfileViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)
        
        nicknameButton.rx.tap
            .subscribe({ _ in
//                self.signUpDataManager.postCheckNickname(viewController: self, nickname: self.nicknameTextField.text!)
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
                UserInfo.shared.gender = "M"
                self.manButton.setBlueButton()
                self.womanButton.setGrayButton()
            })
            .disposed(by: disposeBag)
        
        womanButton.rx.tap
            .subscribe({ _ in
                UserInfo.shared.gender = "F"
                self.manButton.setGrayButton()
                self.womanButton.setBlueButton()
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .subscribe({ [self] _ in
                UserInfo.shared.nickName = self.nicknameTextField.text!
                UserInfo.shared.birthday = self.birthTextField.text!
                UserInfo.shared.fcmToken = Messaging.messaging().fcmToken ?? ""
//                self.signUpDataManager.postSignUp(viewController: self)
            })
            .disposed(by: disposeBag)
    }
//
    private func viewModelOutput() {
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
    }

    private var scrollView = UIScrollView().then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = false
    }
    
    private var contentView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var profileImageView = UIImageView().then { view in
        view.image = Asset.icMyProfile.image
    }
    
    private var profileIcon = UIImageView().then { view in
        view.image = Asset.icEditProfile.image
    }

    private var navBar = NavBar().then{ make in
        make.leftBtnItem.isHidden = false
        make.titleLabel.isHidden = false
        make.titleLabel.text = L10n.MyPage.EditProfile.title
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
        make.setBlueButton()
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
    
    private var confirmButton = LongButton().then { make in
        make.setTitle(L10n.Edit.title, for: .normal)
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
            self?.validCheckArray[2] = true
            self?.checkAllPass()
            
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

extension EditProfileViewController {
    
    private func setupViews() {
        
        view.addSubviews([
            navBar,
            scrollView,
            confirmButton
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            profileImageView,
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
        ])
        
        profileImageView.addSubview(profileIcon)
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
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.height.equalTo(100)
        }
        
        profileIcon.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(profileImageView)
            make.width.height.equalTo(24)
        }
        
        nicknameTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(profileImageView.snp.bottom).offset(36)
            make.leading.equalTo(contentView.snp.leading).offset(28)
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
        
        confirmButton.snp.makeConstraints{ make in
            make.top.equalTo(jobSelectButton.snp.bottom).offset(56)
            make.leading.equalTo(contentView.snp.leading).offset(28)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.bottom.equalTo(contentView.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -42 : -22)
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate{
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
            birthGuideLabel.isHidden = true
            validCheckArray[1] = true
        }
        else{
            birthGuideLabel.isHidden = false
            validCheckArray[1] = false
        }
        checkAllPass()
        
        return false
    }
}
