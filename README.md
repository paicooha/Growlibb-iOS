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
- RxSwift(+RxCocoa): 일관된 코드로 비동기 프로그래밍 구현
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

### 디렉토리 구조

```bash
.
├── Growlibb
│   ├── Growlibb
│   │   ├── AppDelegate.swift
│   │   ├── Base.lproj
│   │   │   ├── LaunchScreen.storyboard
│   │   │   └── Main.storyboard
│   │   ├── GoogleService-Info.plist
│   │   ├── Growlibb.entitlements
│   │   ├── Info.plist
│   │   ├── Resources
│   │   │   ├── Assets.xcassets
│   │   │   ├── Localization
│   │   │   │   ├── en.lproj
│   │   │   │   └── ko.lproj
│   │   │   │       └── Localizable.strings
│   │   │   └── UIColor+Zeplin.swift
│   │   ├── SceneDelegate.swift
│   │   ├── Sources
│   │   │   ├── App
│   │   │   │   ├── AppComponent.swift
│   │   │   │   ├── AppContext.swift
│   │   │   │   └── AppCoordinator.swift
│   │   │   ├── Base
│   │   │   │   ├── BaseAPI.swift
│   │   │   │   ├── BaseResponse.swift
│   │   │   │   ├── BaseViewController.swift
│   │   │   │   ├── BaseViewModel.swift
│   │   │   │   ├── BasicCoordinator.swift
│   │   │   │   └── BasicResponse.swift
│   │   │   ├── Common	       // 도메인 모두 Component, ViewModel, ViewController, Coordinator로 통일
│   │   │   │   ├── Alert
│   │   │   │   ├── KeyChain
│   │   │   │   │   ├── BasicLoginKeyChainService.swift
│   │   │   │   │   ├── BasicUserKeyChainService.swift
│   │   │   │   │   ├── LoginKeyChainService.swift
│   │   │   │   │   └── UserKeyChainService.swift
│   │   │   │   ├── Modal
│   │   │   │   ├── Model
│   │   │   ├── Constants.swift
│   │   │   ├── Extensions
│   │   │   │   ├── UIButton+.swift
│   │   │   │   ├── UIScreen+.swift
│   │   │   │   ├── UIStackView+.swift
│   │   │   │   ├── UITableView+.swift
│   │   │   │   ├── UITextField+.swift
│   │   │   │   ├── UITextView+.swift
│   │   │   │   └── UIView+.swift
│   │   │   ├── FindEmailorPassword
│   │   │   │   ├── Model
│   │   │   │   └── Network
│   │   │   ├── Login
│   │   │   │   ├── Model
│   │   │   │   └── Network
│   │   │   ├── MainTabbar
│   │   │   │   ├── Home
│   │   │   │   │   ├── Cell
│   │   │   │   │   ├── Model
│   │   │   │   │   └── Network
│   │   │   │   ├── MyPage
│   │   │   │   │   ├── CSCenter
│   │   │   │   │   │   ├── Noti
│   │   │   │   │   │   ├── Privacy
│   │   │   │   │   │   └── TermsOfUse
│   │   │   │   │   ├── Cell
│   │   │   │   │   ├── EditNoti
│   │   │   │   │   ├── EditPhoneNumber
│   │   │   │   │   ├── EditProfile
│   │   │   │   │   ├── Editpassword
│   │   │   │   │   │   ├── First
│   │   │   │   │   │   └── Second
│   │   │   │   │   ├── Model
│   │   │   │   │   ├── Network
│   │   │   │   │   ├── Resign
│   │   │   │   │   └── RetrospectList
│   │   │   │   │       ├── DetailRetrospect
│   │   │   │   │       ├── EditRetrospect
│   │   │   │   │       │   ├── Config
│   │   │   │   │       ├── Model
│   │   │   │   ├── Retrospect
│   │   │   │   │   ├── Model
│   │   │   │   │   ├── Network
│   │   │   │   │   ├── View
│   │   │   │   │   └── WriteRetrospect
│   │   │   │   └── WriteRetrospect
│   │   │   │       ├── Cell
│   │   │   │       ├── Config
│   │   │   │       ├── Model
│   │   │   │       ├── Netwotrk
│   │   │   │       ├── TutorialModal
│   │   │   ├── SignUp
│   │   │   │   ├── Final
│   │   │   │   ├── First
│   │   │   │   ├── Model
│   │   │   │   ├── Network
│   │   │   │   └── Second
│   │   │   ├── Tutorial
│   │   │   │   ├── First
│   │   │   │   └── Second
│   │   │   └── Utils
│   │   │       ├── DateUtil
│   │   │       │   ├── DateFormat.swift
│   │   │       │   └── DateUtil.swift
│   │   │       ├── JSONError.swift
│   │   │       ├── Log.swift
│   │   │       ├── MoyaPlugin.swift
│   │   │       ├── Regex.swift
│   │   │       └── RxResponse.swift
```


## 트러블 슈팅 & 개선사항

1. UITableViewCell이 한번에 인식되지 않고, 꾹 눌러야만 인식되는 이슈
2. 앱이 백그라운드 -> 포그라운드로 올 때 캘린더가 이전 날짜로 표시되는 현상 (앱 생명주기 관련)

하단 링크를 통해 상세 과정과 내용을 확인하실 수 있습니다.

[클릭 시 링크 이동](https://windy-laundry-812.notion.site/80209bde9b074c09b8218bf160b3baa8?pvs=4)
