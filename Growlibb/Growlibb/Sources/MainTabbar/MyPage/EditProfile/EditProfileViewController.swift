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
import FirebaseStorage
import Kingfisher
import Photos
import AnyFormatKit

final class EditProfileViewController: BaseViewController {
    let storage = Storage.storage() //인스턴스 생성
    
    let jobList = [L10n.Job.it, L10n.Job.man, L10n.Job.pub, L10n.Job.off, L10n.Job.res, L10n.Job.arc, L10n.Job.med,
                   L10n.Job.hel, L10n.Job.pla, L10n.Job.des,
                   L10n.Job.sel, L10n.Job.hou, L10n.Job.stu, L10n.Job.etc, L10n.Job.not]
    private var userKeyChainService: UserKeychainService
    private var loginKeyChainService: LoginKeyChainService
    
    let processor = ResizingImageProcessor(referenceSize: CGSize(width: 100, height: 100)) |> RoundCornerImageProcessor(cornerRadius: 50)
    
    //닉네임 중복확인 체크여부를 확인 v230322 성별, 생년월일, 직업 기입 선택사항으로 변화
    var validCheck = false

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
        if validCheck { //모두 true
            confirmButton.setEnable()
        }
        else{
            confirmButton.setDisable()
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        validCheck = false
        nicknameGuideLabel.isHidden = true
        
        if nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 1 && nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != UserInfo.shared.nickName {
            nicknameButton.setEnable()
            checkMaxLength(textField: textField, maxLength: 10)
        }
        else{
            validCheck = true
            nicknameButton.setDisable()
        }
        checkAllPass()
    }
    
    private var viewModel: EditProfileViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)
        
        nicknameButton.rx.tap
            .subscribe({ _ in
                self.viewModel.inputs.checkNickName.onNext(self.nicknameTextField.text!)
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
        
        profileImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self
                
                picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                PHPhotoLibrary.requestAuthorization { [weak self] status in
                    DispatchQueue.main.async {
                        switch status {
                        case .authorized:
                            self?.present(picker, animated: true)
                        default:
                            AppContext.shared.makeToast("설정화면에서 앨범 접근권한을 설정해주세요")
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
                
        
        confirmButton.rx.tap
            .subscribe({ [self] _ in
                UserInfo.shared.nickName = self.nicknameTextField.text!
                UserInfo.shared.birthday = self.birthTextField.text!
                viewModel.inputs.complete.onNext(())
                print(UserInfo.shared)
            })
            .disposed(by: disposeBag)
    }
//
    private func viewModelOutput() {
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.mypage
            .subscribe(onNext: { mypage in
                UserInfo.shared.nickName = mypage.nickname
                self.nicknameTextField.text = mypage.nickname
                
                UserInfo.shared.profileUrl = mypage.profileImageUrl
                self.profileImageView.kf.setImage(with: URL(string: mypage.profileImageUrl ?? ""), placeholder: Asset.icMyProfile.image, options: [.processor(self.processor)])
                
                if mypage.job != nil {
                    UserInfo.shared.job = mypage.job
                    self.jobSelectButton.setTitle(mypage.job, for: .normal)
                    self.jobSelectButton.setTitleColor(.black, for: .normal)
                }

                if mypage.birthday != nil {
                    UserInfo.shared.birthday = mypage.birthday
                    self.birthTextField.text = mypage.birthday
                }
                
                if mypage.gender == "M" {
                    self.manButton.setBlueButton()
                    self.womanButton.setGrayButton()
                    UserInfo.shared.gender = "M"
                }
                else if mypage.gender == "F" {
                    self.manButton.setGrayButton()
                    self.womanButton.setBlueButton()
                    UserInfo.shared.gender = "F"
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.checkNickname
            .subscribe(onNext: { isValidNickname in
                if isValidNickname {
//                    self.confirmButton.setEnable()
                    self.nicknameGuideLabel.isHidden = false
                    self.nicknameGuideLabel.text = L10n.SignUp.Nickname.Guidelabel.valid
                    self.validCheck = true
                }
                else{
//                    self.confirmButton.setDisable()
                    self.nicknameGuideLabel.isHidden = false
                    self.nicknameGuideLabel.text = L10n.SignUp.Nickname.Guidelabel.exist
                    self.validCheck = false
                }
                self.checkAllPass()
            })
            .disposed(by: disposeBag)
    }
    
    private var scrollView = UIScrollView().then { view in
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var contentView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var profileImageView = UIImageView().then { view in
        view.image = Asset.icMyProfile.image
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = view.frame.size.width / 2
        view.clipsToBounds = true
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
        make.setDisable() //처음에 변경 전이기 때문에 비활성화함
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
    
    private var confirmButton = LongButton().then { make in
        make.setTitle(L10n.Edit.title, for: .normal)
        make.setEnable() //처음엔 다 채워져있기때문에 enable
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
    
    func uploadFirebase(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        
        let firebaseReference = Storage.storage().reference().child("\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                print(url)
                self.profileImageView.kf.setImage(with: url, placeholder: Asset.icMyProfile.image, options: [.processor(self.processor)])
                UserInfo.shared.profileUrl = url!.absoluteString
            }
        }
    }
}

// MARK: - Layout

extension EditProfileViewController {
    
    private func setupViews() {
        
        view.addSubviews([
            scrollView,
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            navBar,
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
            confirmButton
        ])
        
        profileImageView.addSubview(profileIcon)
    }

    private func initialLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
        
        navBar.topNotchView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        
        navBar.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(100)
        }
        
        profileIcon.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(profileImageView)
            make.width.height.equalTo(24)
        }
        
        nicknameTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(profileImageView.snp.bottom).offset(36)
            make.leading.equalTo(view.snp.leading).offset(28)
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
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        genderTitleLabel.snp.makeConstraints{ make in
            make.leading.equalTo(nicknameTitleLabel.snp.leading)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(36)
        }
        
        manButton.snp.makeConstraints{ make in
            make.leading.equalTo(genderTitleLabel.snp.leading)
            make.top.equalTo(genderTitleLabel.snp.bottom).offset(5)
            make.trailing.equalTo(view.snp.centerX).offset(-6)
        }
        
        womanButton.snp.makeConstraints{ make in
            make.centerY.equalTo(manButton.snp.centerY)
            make.leading.equalTo(view.snp.centerX).offset(6)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        birthTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(manButton.snp.bottom).offset(36)
            make.leading.equalTo(manButton.snp.leading)
        }
        
        birthTextField.snp.makeConstraints{ make in
            make.top.equalTo(birthTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(birthTitleLabel.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
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
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        dropdownImageView.snp.makeConstraints { make in
            make.centerY.equalTo(jobSelectButton.snp.centerY)
            make.trailing.equalTo(jobSelectButton.snp.trailing).offset(-28)
        }
        
        confirmButton.snp.makeConstraints{ make in
            make.top.equalTo(dropdownImageView.snp.bottom).offset(56)
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
            self.validCheck = true
            birthGuideLabel.isHidden = true
        }
        else if !textFieldText.isEmpty && !Regex().isValidBirthday(input: textFieldText.replacingOccurrences(of: "-", with: "")) {
            self.validCheck = false
            birthGuideLabel.isHidden = false
        } else if textFieldText.isEmpty {
            self.validCheck = true //생년월일 정보를 지우고싶을 수 있으므로
        }
        checkAllPass()
        
        return false
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let originalImage = info[.originalImage] as? UIImage
        let editedImage = info[.editedImage] as? UIImage
        
        uploadFirebase(image: editedImage ?? originalImage!)
        
        picker.dismiss(animated: true)
    }

    func photoAuth() -> Bool {
        let authorizationState = PHPhotoLibrary.authorizationStatus()
        var isAuth = false

        switch authorizationState {
        case .authorized:
            return true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized {
                    isAuth = true
                }
            }
            return isAuth
        case .restricted:
            break
        case .denied:
            break
        case .limited:
            break
        @unknown default:
            break
        }
        return false
    }

    func cameraAuth() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized
    }

    func authSettingOpen(authString: String) {
        if let AppName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let message = "\(AppName)이(가) \(authString) 접근 허용이 되어있지 않습니다. \r\n 설정화면으로 가시겠습니까?"
            let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)

            let cancel = UIAlertAction(title: "취소", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
                print("\(String(describing: action.title)) 클릭")
            }

            let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }

            alert.addAction(cancel)
            alert.addAction(confirm)

            present(alert, animated: true, completion: nil)
        }
    }
}
