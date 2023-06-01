# 📚그로우립

## 프로젝트 개요
회고를 희망하는 사람들이 손쉽게 회고를 작성할 수 있도록 도와주는 회고 작성 서비스

- 기간 : 2022.11 ~ 2023.03 개발, 배포 및 운영중
- 팀 구성: Planner/PM, Designer, iOS, Android, Server
- Appstore: [https://apps.apple.com/kr/app/그로우립/id1660732969](https://apps.apple.com/kr/app/%EA%B7%B8%EB%A1%9C%EC%9A%B0%EB%A6%BD/id1660732969)


## 개발 환경
**StoryBoard vs Code**

- 코드 방식으로 개발 (SnapKit)

**디자인패턴**

- MVVM 패턴

**라이브러리**

- Alamofire: API 통신에 사용
- RxSwift(+RxCocoa): 
- Firebase
   - Analytics/Crashlytics  : 유저 리포트 및 버그 트래킹을 위해 활용
   - Cloud Messaging: 푸시알림 구현에 활용
   - Storage: 사진을 이미지로 변환하여 url로 저장함에 있어서 파이어베이스에 이미지 저장해서 나온 url 활용


## 주요 화면

<img src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/5c583987-a826-4a9d-b6dd-d24b2dd4f7f2" width="250"/>
<img src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/c114b295-682f-4e0e-a54e-8454b1918741" width="250"/>
<img src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/4eb48e18-9d88-4b0b-b64c-58f85a36a902" width="250"/>

## 시연 영상
[![Video Label](http://img.youtube.com/vi/uobFbsYq9Tg/0.jpg)](https://youtu.be/uobFbsYq9Tg)

##  주요 기능

### ⭐️ KPT를 활용한 회고 작성
- 날짜별로 문제점, 지속할 점, 새로 시도할 점 등을 나누어 작성 가능

### ⭐️ 홈, 마이페이지를 통한 회고 기록 확인
- 홈에서 회고 기록 캘린더를 확인 가능
- 마이페이지에서 작성한 회고 기록 및 상세 조회 가능

### ⭐️ 회고 작성을 통한 레벨업 & 새싹이 키우기
- 회고 작성을 연속으로 할 때마다 새싹이가 점점 자라도록 할 수 있는 이벤트


## 디렉토리 구조

<details><summary>디렉토리 구조 보기
</summary>

```bash
.
├── AppDelegate.swift
├── Base.lproj
│   ├── LaunchScreen.storyboard
│   └── Main.storyboard
├── GoogleService-Info.plist
├── Growlibb.entitlements
├── Info.plist
├── Resources
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   └── Contents.json
│   ├── Font
│   ├── Font.swift
│   ├── Generated
│   │   ├── Assets+Generated.swift
│   │   └── Localizable+Generated.swift
│   ├── Images.xcassets
│   ├── Localization
│   │   └── ko.lproj
│   │       └── Localizable.strings
│   └── UIColor+Zeplin.swift
├── SceneDelegate.swift
├── Sources
│   ├── App
│   │   ├── AppComponent.swift
│   │   ├── AppContext.swift
│   │   └── AppCoordinator.swift
│   ├── Base
│   │   ├── BaseAPI.swift
│   │   ├── BaseResponse.swift
│   │   ├── BaseViewController.swift
│   │   ├── BaseViewModel.swift
│   │   ├── BasicCoordinator.swift
│   │   └── BasicResponse.swift
│   ├── Common
│   │   ├── Alert
│   │   ├── KeyChain
│   │   │   ├── BasicLoginKeyChainService.swift
│   │   │   ├── BasicUserKeyChainService.swift
│   │   │   ├── LoginKeyChainService.swift
│   │   │   └── UserKeyChainService.swift
│   │   ├── LogoImageView.swift
│   │   ├── LongButton.swift
│   │   ├── Modal
│   │   │   ├── ModalComponent.swift
│   │   │   ├── ModalCoordinator.swift
│   │   │   ├── ModalViewController.swift
│   │   │   └── ModalViewModel.swift
│   │   ├── Model
│   │   │   └── UserInfo.swift
│   │   ├── NavBar.swift
│   │   ├── RetrospectPlusButton.swift
│   │   ├── ShortButton.swift
│   │   └── TextField.swift
│   ├── Constants.swift
│   ├── Extensions
│   │   ├── UIButton+.swift
│   │   ├── UIScreen+.swift
│   │   ├── UIStackView+.swift
│   │   ├── UITableView+.swift
│   │   ├── UITextField+.swift
│   │   ├── UITextView+.swift
│   │   └── UIView+.swift
│   ├── FindEmailorPassword
│   │   ├── FindEmailorPasswordComponent.swift
│   │   ├── FindEmailorPasswordCoordinator.swift
│   │   ├── FindEmailorPasswordViewController.swift
│   │   ├── FindEmailorPasswordViewModel.swift
│   │   ├── Model
│   │   │   ├── PatchResetPasswordRequest.swift
│   │   │   ├── PostFindEmailRequest.swift
│   │   │   ├── PostFindEmailResponse.swift
│   │   │   └── PostFindPasswordRequest.swift
│   │   └── Network
│   │       └── FindDataManager.swift
│   ├── Login
│   │   ├── LoginComponent.swift
│   │   ├── LoginCoordinator.swift
│   │   ├── LoginViewController.swift
│   │   ├── LoginViewModel.swift
│   │   ├── Model
│   │   │   ├── GetJwtResponse.swift
│   │   │   ├── LoginToken.swift
│   │   │   ├── LoginType.swift
│   │   │   ├── PatchFcmRequest.swift
│   │   │   ├── PostLoginRequest.swift
│   │   │   └── PostLoginResponse.swift
│   │   └── Network
│   │       └── LoginDataManager.swift
│   ├── MainTabbar
│   │   ├── Home
│   │   │   ├── Cell
│   │   │   │   └── HomeRetrospectTableViewCell.swift
│   │   │   ├── HomeComponent.swift
│   │   │   ├── HomeCoordinator.swift
│   │   │   ├── HomeViewController.swift
│   │   │   ├── HomeViewModel.swift
│   │   │   ├── Model
│   │   │   │   └── GetHomeResponse.swift
│   │   │   └── Network
│   │   │       └── HomeDataManager.swift
│   │   ├── MainTabComponent.swift
│   │   ├── MainTabbarController.swift
│   │   ├── MainTabbarCoordinator.swift
│   │   ├── MainTabbarViewModel.swift
│   │   ├── MyPage
│   │   │   ├── CSCenter
│   │   │   │   ├── CSComponent.swift
│   │   │   │   ├── CSCoordinator.swift
│   │   │   │   ├── CSViewController.swift
│   │   │   │   ├── CSViewModel.swift
│   │   │   │   ├── FAQ
│   │   │   │   │   └── FAQViewController.swift
│   │   │   │   ├── Noti
│   │   │   │   │   └── NotiViewController.swift
│   │   │   │   ├── Privacy
│   │   │   │   │   └── PrivacyViewController.swift
│   │   │   │   └── TermsOfUse
│   │   │   │       └── TermsOfUseViewController.swift
│   │   │   ├── Cell
│   │   │   │   ├── MyPageCell.swift
│   │   │   │   ├── MyPageDataSource.swift
│   │   │   │   └── RetrospectListCell.swift
│   │   │   ├── EditNoti
│   │   │   │   ├── EditNotiComponent.swift
│   │   │   │   ├── EditNotiCoordinator.swift
│   │   │   │   ├── EditNotiViewController.swift
│   │   │   │   └── EditNotiViewModel.swift
│   │   │   ├── EditPhoneNumber
│   │   │   │   ├── EditPhoneNumberComponent.swift
│   │   │   │   ├── EditPhoneNumberCoordinator.swift
│   │   │   │   ├── EditPhoneNumberViewController.swift
│   │   │   │   └── EditPhoneNumberViewModel.swift
│   │   │   ├── EditProfile
│   │   │   │   ├── EditProfileComponent.swift
│   │   │   │   ├── EditProfileCoordinator.swift
│   │   │   │   ├── EditProfileViewController.swift
│   │   │   │   └── EditProfileViewModel.swift
│   │   │   ├── Editpassword
│   │   │   │   ├── First
│   │   │   │   │   ├── EditPasswordFirstComponent.swift
│   │   │   │   │   ├── EditPasswordFirstCoordinator.swift
│   │   │   │   │   ├── EditPasswordFirstViewController.swift
│   │   │   │   │   └── EditPasswordFirstViewModel.swift
│   │   │   │   └── Second
│   │   │   │       ├── EditPasswordSecondComponent.swift
│   │   │   │       ├── EditPasswordSecondCoordinator.swift
│   │   │   │       ├── EditPasswordSecondViewController.swift
│   │   │   │       └── EditPasswordSecondViewModel.swift
│   │   │   ├── Model
│   │   │   │   ├── GetMyPageTabResponse.swift
│   │   │   │   ├── GetMyProfileResponse.swift
│   │   │   │   ├── PatchPasswordRequest.swift
│   │   │   │   ├── PatchProfileRequest.swift
│   │   │   │   ├── PostCheckPasswordRequest.swift
│   │   │   │   └── ResignReason.swift
│   │   │   ├── MyPageComponent.swift
│   │   │   ├── MyPageCoordinator.swift
│   │   │   ├── MyPageViewController.swift
│   │   │   ├── MyPageViewModel.swift
│   │   │   ├── Network
│   │   │   │   ├── MyPageAPI.swift
│   │   │   │   └── MyPageAPIService.swift
│   │   │   ├── Resign
│   │   │   │   ├── ResignComponent.swift
│   │   │   │   ├── ResignCoordinator.swift
│   │   │   │   ├── ResignViewController.swift
│   │   │   │   └── ResignViewModel.swift
│   │   │   └── RetrospectList
│   │   │       ├── DetailRetrospect
│   │   │       │   ├── DetailRetrospectComponent.swift
│   │   │       │   ├── DetailRetrospectCoordinator.swift
│   │   │       │   ├── DetailRetrospectViewController.swift
│   │   │       │   └── DetailRetrospectViewModel.swift
│   │   │       ├── EditRetrospect
│   │   │       │   ├── Config
│   │   │       │   │   ├── EditRetrospectConfig.swift
│   │   │       │   │   └── EditRetrospectDataSource.swift
│   │   │       │   ├── EditRetrospectComponent.swift
│   │   │       │   ├── EditRetrospectCoordinator.swift
│   │   │       │   ├── EditRetrospectViewController.swift
│   │   │       │   └── EditRetrospectViewModel.swift
│   │   │       ├── Model
│   │   │       │   ├── GetDetailRetrospectResponse.swift
│   │   │       │   ├── GetRetrospectListResponse.swift
│   │   │       │   └── PatchRetrospectRequest.swift
│   │   │       ├── RetrospectListComponent.swift
│   │   │       ├── RetrospectListCoordinator.swift
│   │   │       ├── RetrospectListViewController.swift
│   │   │       └── RetrospectListViewModel.swift
│   │   ├── Retrospect
│   │   │   ├── Model
│   │   │   │   └── GetRetrospectTabResponse.swift
│   │   │   ├── Network
│   │   │   │   ├── RetrospectAPI.swift
│   │   │   │   └── RetrospectAPIService.swift
│   │   │   ├── RetrospectComponent.swift
│   │   │   ├── RetrospectCoordinator.swift
│   │   │   ├── RetrospectViewController.swift
│   │   │   ├── RetrospectViewModel.swift
│   │   │   ├── View
│   │   │   │   ├── RetrospectLeftView.swift
│   │   │   │   └── RetrospectRightView.swift
│   │   │   └── WriteRetrospect
│   │   │       └── NotSaveAlert
│   │   └── WriteRetrospect
│   │       ├── Cell
│   │       │   └── WriteRetrospectCell.swift
│   │       ├── Config
│   │       │   └── WriteRetrospectDataSource.swift
│   │       ├── Model
│   │       │   └── PostRetrospectReqeust.swift
│   │       ├── Netwotrk
│   │       │   ├── WriteRetrospectAPI.swift
│   │       │   └── WriteRetrospectAPIService.swift
│   │       ├── TutorialModal
│   │       │   ├── WriteRetrospectTutorialModalComponent.swift
│   │       │   ├── WriteRetrospectTutorialModalCoordinator.swift
│   │       │   ├── WriteRetrospectTutorialModalViewController.swift
│   │       │   └── WriteRetrospectTutorialModalViewModel.swift
│   │       ├── WriteRetrospectComponent.swift
│   │       ├── WriteRetrospectCoordinator.swift
│   │       ├── WriteRetrospectViewController.swift
│   │       └── WriteRetrospectViewModel.swift
│   ├── SignUp
│   │   ├── Final
│   │   │   ├── SignUpFinalComponent.swift
│   │   │   ├── SignUpFinalCoordinator.swift
│   │   │   ├── SignUpFinalViewController.swift
│   │   │   └── SignUpFinalViewModel.swift
│   │   ├── First
│   │   │   ├── SignUpFirstComponent.swift
│   │   │   ├── SignUpFirstCoordinator.swift
│   │   │   ├── SignUpFirstViewController.swift
│   │   │   └── SignUpFirstViewModel.swift
│   │   ├── Model
│   │   │   ├── PostCheckEmailRequest.swift
│   │   │   ├── PostCheckNicknameRequest.swift
│   │   │   ├── PostCheckPhoneRequest.swift
│   │   │   ├── PostSignUpRequest.swift
│   │   │   └── PostSignUpResponse.swift
│   │   ├── Network
│   │   │   └── SignUpDataManager.swift
│   │   └── Second
│   │       ├── SignUpSecondComponent.swift
│   │       ├── SignUpSecondCoordinator.swift
│   │       ├── SignUpSecondViewController.swift
│   │       └── SignUpSecondViewModel.swift
│   ├── Tutorial
│   │   ├── First
│   │   │   ├── TutorialFirstComponent.swift
│   │   │   ├── TutorialFirstCoordinator.swift
│   │   │   ├── TutorialFirstViewController.swift
│   │   │   └── TutorialFirstViewModel.swift
│   │   └── Second
│   │       ├── TutorialSecondComponent.swift
│   │       ├── TutorialSecondCoordinator.swift
│   │       ├── TutorialSecondViewController.swift
│   │       └── TutorialSecondViewModel.swift
│   └── Utils
│       ├── DateUtil
│       │   ├── DateFormat.swift
│       │   └── DateUtil.swift
│       ├── JSONError.swift
│       ├── Log.swift
│       ├── MoyaPlugin.swift
│       ├── Regex.swift
│       └── RxResponse.swift
├── ViewController.swift
└── a.txt

103 directories, 289 files

```
</details>


## 트러블 슈팅 & 개선사항

## 배우고 습득한 점
