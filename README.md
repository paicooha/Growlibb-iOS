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


## 트러블 슈팅 & 개선사항

<details><summary>1. 마이페이지의 하단 UITableView Cell이 클릭 한 번에 인식되지 않고, 꾹 눌러야만 인식되는 이슈
</summary>
<br/>
  <img width="348" alt="Untitled (17)" src="https://github.com/paicooha/Growlibb-iOS/assets/37764504/55251d0e-a039-453a-bc0b-dd86febfcaba">

❗️ **문제원인**
- 마이페이지 UIViewController가 상속하는 BaseViewController의 화면 일부 클릭 시 키보드를 사라지게 하는 UITapGestureRecognizer가 테이블뷰의 셀 클릭 gesture와 중복되어 이 인식을 방해한 것이 원인

✅ **해결**
   
<img width="800" alt="Untitled (18)" src="https://github.com/paicooha/Growlibb-iOS/assets/37764504/cc795ae6-3da3-41a6-9324-c0594f09f99e">

- BaseViewController의 UITapGestureRecognizer의 cancelTouchesInView의 속성을 false로 지정하였음
- cancelTouchesInView는 기본값이 true로, 해당 값이 true이면 기존 뷰에서 발생하는 이벤트들을 취소하는 속성이 있어 해당 속성으로 인해 UITableView의 클릭을 방해하게 되므로, 해당 값을 false로 하여 기존 이벤트를 취소하지 않게 처리함
   
</details>

<details><summary>2. UITableView 행 삭제를 빠르게 했을 때 앱 크래쉬 나는 현상
</summary>
<br/>

❗️ **문제원인** <br/>
우선 cell에 해당하는 indexPath가 있을거라 장담하고 강제 언래핑을 한 부분도 지양해야하는 코드이지만,

삭제 버튼을 천천히 누르면 튕기지 않는데, 왜 빠르게 연타하면 튕길까? 를 고민해보기 시작했다.

<img width="500" alt="image (9)" src="https://github.com/paicooha/Growlibb-iOS/assets/37764504/292fdcd1-2b7f-40ca-8868-abfc4544cffa">

- 실제로 내가 저 버튼을 누르고 있는 셀의 indexPath를 콘솔로 찍어보니, 연타했을 때 nil 값이 반환되는 것을 확인할 수 있었음

<img width="500" alt="image (10)" src="https://github.com/paicooha/Growlibb-iOS/assets/37764504/e750b0aa-5d4d-4726-b531-8f2d222e2df8">

- 해당 indexPath를 뜯어보면 '셀이 보이지 않으면 nil을 return한다' 라고 나와있음.
관련해서 검색해보니,

https://stackoverflow.com/questions/41856510/tableviewindexpathforcell-returns-nil-when-clicking-in-cell

- 해당 답변을 보고 추측했을 때 셀을 삭제하면서 테이블뷰가 해당 리스트의 뷰를 다시 그리게 되는 과정이 있는데, 다시 그려내기도 전에 (보이지 않는 상황)에서 셀의 인덱스를 찾으려고 시도했기 때문에 nil을 반환했던 것이 아닐까 하고 추측됨   
   

✅ **해결** <br/>
   
- guard를 쳐서 해당 cell의 indexPath를 받아오지 못할 때, 아무 동작을 하지 않도록 처리하였음.
- 강제 언래핑(!)을 지양하고 옵셔널과 guard, if let을 통해 값의 nil 여부나 예상 값이 아닌지 검증한다음에 사용하는 것이 중요하다는 것을 깨닫게 되었음
   
<img width="500" alt="image (11)" src="https://github.com/paicooha/Growlibb-iOS/assets/37764504/b282b355-b678-4e7b-b7eb-e841f7c32980">
  
</details>

<details><summary>3. 앱이 백그라운드 → 포그라운드로 올 때 캘린더가 이전 날짜로 표시되는 현상
</summary>
<br/>

<img width="300" alt="image (12)" src="https://github.com/paicooha/Growlibb-iOS/assets/37764504/7148cf6d-0a28-4e5a-aedf-17d0ce5939a2">

- 3월 20일에 위 타이틀 23.03.19로 표시 되는 현상 + 홈 달력에서 19일이 오늘 날짜로 표시하는 파란색 원으로 표시되는 현상이 제보되었음
- 앱을 종료하지 않고 백그라운드 상태로 두었다가 다시 진입했을 때 나타나는 현상인 것으로 보아 생명주기 관련 이슈인것으로 확인되어서, 뷰 컨트롤러/앱 생명주기 개념을 다시 되짚어보면서 원인을 찾아보기로 했다.
- 덕분에 [이 포스트](https://devyul.tistory.com/entry/iOS-%EC%95%B1-%EC%83%9D%EB%AA%85%EC%A3%BC%EA%B8%B0-%EB%B7%B0%EC%BB%A8%ED%8A%B8%EB%A1%A4%EB%9F%AC%EC%9D%98-%EC%83%9D%EB%AA%85%EC%A3%BC%EA%B8%B0)도 보완하면서 다시 뷰 컨트롤러 + 앱 생명주기에 대해 이해해보는 계기가 되었다.
   
❗️ **문제원인** <br/>

날짜와 캘린더를 viewDidLoad에서 세팅하게 되면서, 앱이 백그라운드에 있다가 다시 돌아올 때에는 viewDidLoad가 이미 실행되어있고 그 이후에 초기화하는 코드가 실행되지 않으므로 이전 데이터로 남아있었음이 원인

✅ **해결**
 
- 앱이 백그라운드 -> 포그라운드로 다시 돌아오는 경우 / 다른 뷰컨트롤러에서 다시 돌아올 때 날짜가 바뀌었을 때 2가지를 해결해줄 필요가 있었음
- 뷰컨트롤러에서 앱의 생명주기를 어떻게 알까? 해서 알아보니 NotificationCenter 를 이용하게 되는것을 확인해서, 이 개념에 대해 공부해보았다. [공부한 포스팅](https://devyul.tistory.com/entry/iOSSwift-Notification-Center)
- Notification Center의 observer를 등록해서, 앱이 active 상태로 진입했을 때의 Notification을 관찰하게 되면 / 다른 화면에 있다가 다시 돌아올 때 
상단 날짜 타이틀과 캘린더의 오늘 날짜를 바꿔주는 메소드를 실행하도록 했다.

```swift
    private var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

//앱이 active 상태로 진입했을 때의 Notification Observer 등록
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [unowned self] _ in
            changeTitleAndCalendarDate()
        }
    }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.userKeyChainService = BasicUserKeyChainService.shared
        super.init()
    }

    deinit {//옵저버 해지 -> 메모리 관리if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    override func viewWillAppear(_ animated: Bool) {//다른 화면에 갔다가 다시 돌아올 때에도 날짜를 바꿔줄 필요가 있으므로 viewWillAppear에서 함수 실행
        changeTitleAndCalendarDate()
    }
```

```swift
    func changeTitleAndCalendarDate(){
        if dateLabel.text != DateUtil.shared.formattedString(for: DateUtil.shared.now, format: .yyMMdd) {//날짜가 달라진 경우 바꿔주기
            dateLabel.text = DateUtil.shared.formattedString(for: DateUtil.shared.now, format: .yyMMdd)
            calendar.appearance.todayColor = .primaryBlue//오늘날짜로 파란 dot 재설정
            calendar.reloadData()
        }
    }
```  
   
<br/>
   

  
</details>

