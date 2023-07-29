# 📚 그로우립

## 프로젝트 소개

회고를 희망하는 사람들이 손쉽게 회고를 작성할 수 있도록 도와주는 회고 작성 서비스
- 기간 : 2022.11 ~ 2023.03 개발, 배포 및 운영중
- 역할 : iOS 개발 100%
- 팀 구성: iOS 개발자 1명, Android 개발자 1명, 백엔드 개발자 1명, 디자이너 1명, PM 1명
- Appstore: [https://apps.apple.com/kr/app/그로우립/id1660732969](https://apps.apple.com/kr/app/%EA%B7%B8%EB%A1%9C%EC%9A%B0%EB%A6%BD/id1660732969)


## Tech Stack

-   **언어**  : Swift
-   **UI**: UIKit, 코드 방식(SnapKit)
-   **아키텍처**  : MVVM + Coordinator
-   **비동기 처리**  : RxSwift, RxCocoa, DispatchQueue
-   **네트워킹** : Alamofire
-   **기타**: Firebase Auth (문자 인증), Cloud Messaging (푸시알림), Analytics/Crashlytics (유저 및 버그 리포트)
-   **협업**:  Figma, Zeplin


## 아키텍처
### MVVM-C
<img width="500" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/0e9cc9b1-1e9b-44f4-8d17-98f4e58f0b87"/> <br/>

- **App**: AppCoordinator, AppContext(앱 전체에 공통적으로 적용되는 속성 혹은 기능 정의)
- **Common**: 앱 공통적으로 쓰이는 모달과 같은 컴포넌트, 모델, UI / 유용한 도구 모음 Util / Extension, Localization 등
- **Feature**: 
  - 튜토리얼, 회원가입, 로그인, 아이디/비밀번호 찾기
  - 탭바 기준으로 Home, Retrospect, MyPage로 분리
  - 각 Feature는 ViewController, ViewModel, Component, Coordinator를 가짐
- **Component**: 화면 별로 필요한 ViewController, ViewModel을 소유하며 화면 전환 가능성이 있는 Component를 생성 및 전달
- **Coordinator**: ViewController의 화면 전환 및 전환에 따른 추가 작업 로직 분리, 화면 계층 관리
 - **ViewModel**: Alamofire 기반의 APIService에서 통신한 내용과 UserDefaults의 localDB에 의존하여 데이터를 획득하며, View는 ViewModel을 바인딩함 (RxSwift, RxCocoa)

## Experience
-  **회원가입 시 앱 기능에 불필요한 정보를 요구하면 리젝**당할 수 있음을 깨닫고, 불필요한 정보는 선택사항으로 입력할 수 있도록 수정하여 리젝 이슈에 대응하였음
-   iPhone 8/SE/미니와 같은 해상도가 작은 기기에서 Autolayout이 화면 요구사항과 달라질 수 있음을 인지하고, **레이아웃에서 뷰가 차지하는 비율 및 UIScreen의 bounds 속성을 이용해 아이폰 기종별로 화면 요구사항이 적절하게 구현될 수 있도록 대응**해보는 계기가 되었음
-   **Extension**을 사용하여 프로젝트에서 사용하는 클래스에서 공통적으로 요구되는 추가 속성 및 메소드를 모듈화할 수 있음을 깨달았고, 자주 쓰이는 속성이나 메소드를 extension으로 관리하는 계기가 되었음
-   UI와 UX를 디자이너와 논의 및 개선하면서 중요성을 인지하고, Human Interface Guideline에 대한 중요성을 확인할 수 있었던 계기가 된 프로젝트. 이후 진행하는 프로젝트는 해당 가이드라인에 기반하여 디자이너와 논의할 예정

## 주요 기능 설명

**1) 로그인 / 회원가입 / 비밀번호 찾기**
- 이메일 로그인 방식이며 인증은 휴대폰 번호로 진행합니다. (Firebase Auth)

<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/5e31ba9b-8968-4b47-8851-192d39570587" />  <img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/251f4d72-a25a-49bd-9ab7-41560d0e548b" />  <img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/d2a5b1af-10ea-4f2b-b4e2-d3c58d0e1395" />

**2) 홈 화면**
일주일간 작성한 회고 기록, 해당 월 회고 데이터를 달력을 통해 확인할 수 있습니다.

<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/9e18e8bf-65e1-482d-9a84-798939f3944b" /> 

**3) 회고 탭**
회고 기록 현황을 애니메이션과 함께 보여주고, 회고를 DONE / KEEP / PROBLEM / TRY에 따라 작성할 수 있습니다.

<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/de76de06-8554-475f-accd-1fa2f57d0ecf" />
<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/441b1dce-7a1a-4bed-b188-f4974f440a74" />

**4) 마이페이지**
- 회고 기록 확인, 회고 수정, 프로필 수정, 기타 알림 설정 등을 제공합니다,

<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/c3029aeb-2bb1-44fa-8ae1-461ccdafc646" />
<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/57aabd61-2bb3-4d3e-b336-2ab1e3d4f542" /> <img src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/3b01b00d-c891-4a34-b516-b068eed7b17d" width="200" />
