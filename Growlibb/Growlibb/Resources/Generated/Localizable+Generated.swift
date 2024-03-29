// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Localizable.strings
  ///   Growlibb
  /// 
  ///   Created by 이유리 on 2022/11/10.
  internal static let locale = L10n.tr("Localizable", "Locale", fallback: "Ko-kr")
  internal enum Confirm {
    internal enum Button {
      /// 확인
      internal static let title = L10n.tr("Localizable", "Confirm.Button.title", fallback: "확인")
    }
  }
  internal enum Edit {
    /// 수정하기
    internal static let title = L10n.tr("Localizable", "Edit.title", fallback: "수정하기")
  }
  internal enum Find {
    internal enum Email {
      internal enum Find {
        /// 이메일을 찾았어요!
        internal static let title = L10n.tr("Localizable", "Find.email.find.title", fallback: "이메일을 찾았어요!")
      }
      internal enum Guide {
        /// 이메일을 찾기 위해서는 휴대폰 번호를 입력해야 해요.
        internal static let title = L10n.tr("Localizable", "Find.email.guide.title", fallback: "이메일을 찾기 위해서는 휴대폰 번호를 입력해야 해요.")
      }
      internal enum Notfind {
        /// 등록되지 않은 휴대폰 번호입니다.
        internal static let guidelabel = L10n.tr("Localizable", "Find.email.notfind.guidelabel", fallback: "등록되지 않은 휴대폰 번호입니다.")
      }
      internal enum Tab {
        /// 이메일 찾기
        internal static let title = L10n.tr("Localizable", "Find.email.tab.title", fallback: "이메일 찾기")
      }
    }
    internal enum Password {
      internal enum Button {
        /// 변경하기
        internal static let title = L10n.tr("Localizable", "Find.password.button.title", fallback: "변경하기")
      }
      internal enum Find {
        /// 비밀번호를 재설정 해주세요!
        internal static let title = L10n.tr("Localizable", "Find.password.find.title", fallback: "비밀번호를 재설정 해주세요!")
      }
      internal enum Guide {
        /// 비밀번호를 재설정 하기 위해서는 이메일, 휴대폰 번호를 입력해야 해요.
        internal static let title = L10n.tr("Localizable", "Find.password.guide.title", fallback: "비밀번호를 재설정 하기 위해서는 이메일, 휴대폰 번호를 입력해야 해요.")
      }
      internal enum Notfind {
        /// 등록되지 않은 이메일입니다.
        internal static let guidelabel = L10n.tr("Localizable", "Find.password.notfind.guidelabel", fallback: "등록되지 않은 이메일입니다.")
      }
      internal enum Tab {
        /// 비밀번호 재설정
        internal static let title = L10n.tr("Localizable", "Find.password.tab.title", fallback: "비밀번호 재설정")
      }
    }
  }
  internal enum Home {
    internal enum Recent {
      /// 회고 작성 이력이 없어요.
      internal static let nodata = L10n.tr("Localizable", "Home.recent.nodata", fallback: "회고 작성 이력이 없어요.")
      /// 최근 일주일 동안 작성한 회고에요!
      internal static let title = L10n.tr("Localizable", "Home.recent.title", fallback: "최근 일주일 동안 작성한 회고에요!")
    }
    internal enum Title {
      /// 님, 오늘도 화이팅입니다!
      internal static let nickname = L10n.tr("Localizable", "Home.title.nickname", fallback: "님, 오늘도 화이팅입니다!")
    }
  }
  internal enum Job {
    /// 건축사
    internal static let arc = L10n.tr("Localizable", "Job.ARC", fallback: "건축사")
    /// 디자이너
    internal static let des = L10n.tr("Localizable", "Job.DES", fallback: "디자이너")
    /// 기타
    internal static let etc = L10n.tr("Localizable", "Job.ETC", fallback: "기타")
    /// 보건의료인
    internal static let hel = L10n.tr("Localizable", "Job.HEL", fallback: "보건의료인")
    /// 주부
    internal static let hou = L10n.tr("Localizable", "Job.HOU", fallback: "주부")
    /// 기술직(IT/공학계열)
    internal static let it = L10n.tr("Localizable", "Job.IT", fallback: "기술직(IT/공학계열)")
    /// 사무관리직
    internal static let man = L10n.tr("Localizable", "Job.MAN", fallback: "사무관리직")
    /// 의료종사자
    internal static let med = L10n.tr("Localizable", "Job.MED", fallback: "의료종사자")
    /// 무직(퇴직자 포함)
    internal static let not = L10n.tr("Localizable", "Job.NOT", fallback: "무직(퇴직자 포함)")
    /// 경찰/소방/군인
    internal static let off = L10n.tr("Localizable", "Job.OFF", fallback: "경찰/소방/군인")
    /// 기획자
    internal static let pla = L10n.tr("Localizable", "Job.PLA", fallback: "기획자")
    /// 공무원
    internal static let pub = L10n.tr("Localizable", "Job.PUB", fallback: "공무원")
    /// 연구원
    internal static let res = L10n.tr("Localizable", "Job.RES", fallback: "연구원")
    /// 자영업
    internal static let sel = L10n.tr("Localizable", "Job.SEL", fallback: "자영업")
    /// 학생
    internal static let stu = L10n.tr("Localizable", "Job.STU", fallback: "학생")
  }
  internal enum Login {
    /// 반가워요!
    /// GROW.LIBB에 로그인 해주시면
    /// 다양한 컨텐츠를 이용하실 수 있어요!
    internal static let title = L10n.tr("Localizable", "Login.Title", fallback: "반가워요!\nGROW.LIBB에 로그인 해주시면\n다양한 컨텐츠를 이용하실 수 있어요!")
    internal enum Button {
      /// 로그인
      internal static let title = L10n.tr("Localizable", "Login.button.title", fallback: "로그인")
    }
    internal enum Email {
      /// 이메일을 입력해주세요.
      internal static let placeholder = L10n.tr("Localizable", "Login.email.placeholder", fallback: "이메일을 입력해주세요.")
      /// 이메일
      internal static let title = L10n.tr("Localizable", "Login.email.title", fallback: "이메일")
    }
    internal enum Forget {
      /// 이메일 찾기 / 비밀번호 재설정하기
      internal static let find = L10n.tr("Localizable", "Login.forget.find", fallback: "이메일 찾기 / 비밀번호 재설정하기")
      /// 이메일/비밀번호를 까먹으셨다면!
      internal static let title = L10n.tr("Localizable", "Login.forget.title", fallback: "이메일/비밀번호를 까먹으셨다면!")
    }
    internal enum Incorrect {
      /// 이메일 혹은 비밀번호를 다시 입력해주세요.
      internal static let guidelabel = L10n.tr("Localizable", "Login.incorrect.guidelabel", fallback: "이메일 혹은 비밀번호를 다시 입력해주세요.")
    }
    internal enum Notmember {
      /// 회원가입 하러가기
      internal static let gotoSignup = L10n.tr("Localizable", "Login.notmember.gotoSignup", fallback: "회원가입 하러가기")
      /// 아직 회원이 아니신가요?
      internal static let title = L10n.tr("Localizable", "Login.notmember.title", fallback: "아직 회원이 아니신가요?")
    }
    internal enum Password {
      /// 비밀번호를 입력해주세요.
      internal static let placeholder = L10n.tr("Localizable", "Login.password.placeholder", fallback: "비밀번호를 입력해주세요.")
      /// 비밀번호
      internal static let title = L10n.tr("Localizable", "Login.password.title", fallback: "비밀번호")
    }
  }
  internal enum Main {
    internal enum Button {
      /// 회고 수정하러 가기 👉🏻
      internal static let editRetrospect = L10n.tr("Localizable", "Main.Button.editRetrospect", fallback: "회고 수정하러 가기 👉🏻")
      /// 회고 작성하러 가기 👉🏻
      internal static let goRetrospect = L10n.tr("Localizable", "Main.Button.goRetrospect", fallback: "회고 작성하러 가기 👉🏻")
    }
    internal enum HomeTab {
      /// 홈
      internal static let title = L10n.tr("Localizable", "Main.HomeTab.Title", fallback: "홈")
    }
    internal enum MyPage {
      /// 내 메뉴
      internal static let title = L10n.tr("Localizable", "Main.MyPage.Title", fallback: "내 메뉴")
    }
    internal enum RetrospectTab {
      /// 회고
      internal static let title = L10n.tr("Localizable", "Main.RetrospectTab.Title", fallback: "회고")
    }
  }
  internal enum Modify {
    /// 변경하기
    internal static let title = L10n.tr("Localizable", "Modify.title", fallback: "변경하기")
  }
  internal enum MyPage {
    /// 알림
    internal static let editNoti = L10n.tr("Localizable", "MyPage.EditNoti", fallback: "알림")
    internal enum Cs {
      /// FAQ
      internal static let faq = L10n.tr("Localizable", "MyPage.CS.FAQ", fallback: "FAQ")
      /// 공지사항
      internal static let noti = L10n.tr("Localizable", "MyPage.CS.Noti", fallback: "공지사항")
      /// 개인정보처리방침
      internal static let privacy = L10n.tr("Localizable", "MyPage.CS.privacy", fallback: "개인정보처리방침")
      /// 고객센터
      internal static let title = L10n.tr("Localizable", "MyPage.CS.Title", fallback: "고객센터")
      /// 이용약관
      internal static let yakgwan = L10n.tr("Localizable", "MyPage.CS.yakgwan", fallback: "이용약관")
    }
    internal enum EditProfile {
      /// 내 프로필 수정
      internal static let title = L10n.tr("Localizable", "MyPage.EditProfile.title", fallback: "내 프로필 수정")
    }
    internal enum List {
      /// 알림 설정
      internal static let editNoti = L10n.tr("Localizable", "MyPage.List.EditNoti", fallback: "알림 설정")
      /// 비밀번호 변경
      internal static let editPassword = L10n.tr("Localizable", "MyPage.List.EditPassword", fallback: "비밀번호 변경")
      /// 휴대폰번호 변경
      internal static let editPhone = L10n.tr("Localizable", "MyPage.List.EditPhone", fallback: "휴대폰번호 변경")
      /// 내 프로필 수정
      internal static let editProfile = L10n.tr("Localizable", "MyPage.List.EditProfile", fallback: "내 프로필 수정")
      /// 로그아웃
      internal static let logout = L10n.tr("Localizable", "MyPage.List.Logout", fallback: "로그아웃")
      /// 회원탈퇴
      internal static let resign = L10n.tr("Localizable", "MyPage.List.Resign", fallback: "회원탈퇴")
      /// 회고 되돌아보기
      internal static let retrospect = L10n.tr("Localizable", "MyPage.List.Retrospect", fallback: "회고 되돌아보기")
    }
    internal enum Logout {
      /// 🥺
      internal static let emoji = L10n.tr("Localizable", "MyPage.Logout.emoji", fallback: "🥺")
      /// 로그아웃 하시겠습니까?
      internal static let title = L10n.tr("Localizable", "MyPage.Logout.title", fallback: "로그아웃 하시겠습니까?")
    }
    internal enum Point {
      /// 내 포인트
      internal static let title = L10n.tr("Localizable", "MyPage.Point.title", fallback: "내 포인트")
    }
    internal enum Resign {
      /// 계정을 삭제하면 아이디 재사용 불가 및 기존에 작성한 회고이력이 모두 삭제돼요!
      internal static let guide = L10n.tr("Localizable", "MyPage.Resign.guide", fallback: "계정을 삭제하면 아이디 재사용 불가 및 기존에 작성한 회고이력이 모두 삭제돼요!")
      /// 사유를 입력해주세요.
      internal static let placeholder = L10n.tr("Localizable", "MyPage.Resign.placeholder", fallback: "사유를 입력해주세요.")
      /// 님 정말 회원탈퇴 하시겠어요?
      internal static let title = L10n.tr("Localizable", "MyPage.Resign.title", fallback: "님 정말 회원탈퇴 하시겠어요?")
      internal enum Checkbox {
        /// 회원탈퇴 유의사항을 확인하였으며 이에 동의합니다.
        internal static let guide = L10n.tr("Localizable", "MyPage.Resign.Checkbox.guide", fallback: "회원탈퇴 유의사항을 확인하였으며 이에 동의합니다.")
      }
      internal enum Modal {
        /// 👋🏻
        internal static let emoji = L10n.tr("Localizable", "MyPage.Resign.Modal.emoji", fallback: "👋🏻")
        /// 회원탈퇴가 정상적으로 처리되었습니다.
        /// 그 동안 이용해주셔서 감사합니다.
        internal static let title = L10n.tr("Localizable", "MyPage.Resign.Modal.title", fallback: "회원탈퇴가 정상적으로 처리되었습니다.\n그 동안 이용해주셔서 감사합니다.")
      }
      internal enum Reason {
        /// 서비스 탈퇴 사유에 대해 알려주세요.
        /// 피드백을 바탕으로 더 나은 서비스로 보답하겠습니다.
        internal static let subtitle = L10n.tr("Localizable", "MyPage.Resign.Reason.subtitle", fallback: "서비스 탈퇴 사유에 대해 알려주세요.\n피드백을 바탕으로 더 나은 서비스로 보답하겠습니다.")
        /// (선택) 회원탈퇴를 하시는 이유가 궁금해요.
        internal static let title = L10n.tr("Localizable", "MyPage.Resign.Reason.title", fallback: "(선택) 회원탈퇴를 하시는 이유가 궁금해요.")
      }
    }
    internal enum RetrospectCount {
      /// 회고 개수
      internal static let title = L10n.tr("Localizable", "MyPage.RetrospectCount.title", fallback: "회고 개수")
    }
    internal enum SeedLevel {
      /// 새싹 레벨
      internal static let title = L10n.tr("Localizable", "MyPage.SeedLevel.title", fallback: "새싹 레벨")
    }
  }
  internal enum Next {
    internal enum Button {
      /// 다음
      internal static let title = L10n.tr("Localizable", "Next.Button.title", fallback: "다음")
    }
  }
  internal enum No {
    /// 아니오
    internal static let title = L10n.tr("Localizable", "No.title", fallback: "아니오")
  }
  internal enum Retrospect {
    internal enum Edit {
      /// 회고 수정
      internal static let title = L10n.tr("Localizable", "Retrospect.Edit.title", fallback: "회고 수정")
    }
    internal enum Continuous {
      internal enum Description {
        /// 님!
        /// 연속으로 
        internal static let first = L10n.tr("Localizable", "Retrospect.continuous.description.first", fallback: "님!\n연속으로 ")
        /// 번 회고를 작성하셨군요!
        internal static let second = L10n.tr("Localizable", "Retrospect.continuous.description.second", fallback: "번 회고를 작성하셨군요!")
      }
    }
    internal enum Modal {
      internal enum Event {
        /// 🎉
        internal static let emoji = L10n.tr("Localizable", "Retrospect.modal.event.emoji", fallback: "🎉")
        /// 회 연속 회고 작성으로
        /// 
        internal static let first = L10n.tr("Localizable", "Retrospect.modal.event.first", fallback: "회 연속 회고 작성으로\n")
        /// 포인트를 받으셨습니다!
        internal static let second = L10n.tr("Localizable", "Retrospect.modal.event.second", fallback: "포인트를 받으셨습니다!")
        /// 축하합니다!
        /// 
        /// 
        internal static let title = L10n.tr("Localizable", "Retrospect.modal.event.title", fallback: "축하합니다!\n\n")
      }
    }
    internal enum Morecontinuous {
      /// 일만 더 연속으로
      /// 회고를 작성하면 특별한 일이 일어나요!
      internal static let description = L10n.tr("Localizable", "Retrospect.morecontinuous.description", fallback: "일만 더 연속으로\n회고를 작성하면 특별한 일이 일어나요!")
    }
    internal enum Morepoint {
      internal enum Description {
        /// 포인트
        /// 더 모으면 Lv.
        internal static let first = L10n.tr("Localizable", "Retrospect.morepoint.description.first", fallback: "포인트\n더 모으면 Lv.")
        /// 로 올라갈 수 있어요!
        internal static let second = L10n.tr("Localizable", "Retrospect.morepoint.description.second", fallback: "로 올라갈 수 있어요!")
      }
    }
    internal enum Myeongeon {
      /// 오랜 방황 끝에서야 지름길을 찾을 수 있어요.
      internal static let fifth = L10n.tr("Localizable", "Retrospect.myeongeon.fifth", fallback: "오랜 방황 끝에서야 지름길을 찾을 수 있어요.")
      /// 경험을 현명하게 사용한다면 어떤 일도 시간 낭비가 아니에요.
      internal static let first = L10n.tr("Localizable", "Retrospect.myeongeon.first", fallback: "경험을 현명하게 사용한다면 어떤 일도 시간 낭비가 아니에요.")
      /// 과거에 집착하지 말고 현재를 현명하게 개선하세요.
      internal static let fourth = L10n.tr("Localizable", "Retrospect.myeongeon.fourth", fallback: "과거에 집착하지 말고 현재를 현명하게 개선하세요.")
      /// 잠자리에 들기 전, 하루를 검토해봐요.
      internal static let second = L10n.tr("Localizable", "Retrospect.myeongeon.second", fallback: "잠자리에 들기 전, 하루를 검토해봐요.")
      /// 과거를 기억 못하는 사람은 과거를 반복 하기 마련이에요.
      internal static let third = L10n.tr("Localizable", "Retrospect.myeongeon.third", fallback: "과거를 기억 못하는 사람은 과거를 반복 하기 마련이에요.")
    }
    internal enum Point {
      internal enum Description {
        /// 님!
        /// 지금까지 총 
        internal static let first = L10n.tr("Localizable", "Retrospect.point.description.first", fallback: "님!\n지금까지 총 ")
        /// 포인트 획득 하셨군요!
        internal static let second = L10n.tr("Localizable", "Retrospect.point.description.second", fallback: "포인트 획득 하셨군요!")
      }
    }
  }
  internal enum SignUp {
    /// 회원가입
    internal static let title = L10n.tr("Localizable", "SignUp.Title", fallback: "회원가입")
    internal enum Final {
      /// 시작하기
      internal static let button = L10n.tr("Localizable", "SignUp.Final.button", fallback: "시작하기")
      /// 지금부터 회고를 시작해볼까요?
      internal static let guidelabel = L10n.tr("Localizable", "SignUp.Final.guidelabel", fallback: "지금부터 회고를 시작해볼까요?")
      /// 님,
      /// 회원가입에 성공했습니다.
      internal static let title = L10n.tr("Localizable", "SignUp.Final.title", fallback: "님,\n회원가입에 성공했습니다.")
    }
    internal enum First {
      /// 이메일, 비밀번호, 휴대폰 번호를 입력해주세요.
      internal static let title = L10n.tr("Localizable", "SignUp.First.title", fallback: "이메일, 비밀번호, 휴대폰 번호를 입력해주세요.")
    }
    internal enum Second {
      /// 닉네임, 성별, 생년월일, 직업을 입력해주세요.
      internal static let title = L10n.tr("Localizable", "SignUp.Second.title", fallback: "닉네임, 성별, 생년월일, 직업을 입력해주세요.")
    }
    internal enum Agree {
      /// 모두 동의
      internal static let agreall = L10n.tr("Localizable", "SignUp.agree.agreall", fallback: "모두 동의")
      /// 개인정보처리 방침 약관 동의 [필수]
      internal static let privacy = L10n.tr("Localizable", "SignUp.agree.privacy", fallback: "개인정보처리 방침 약관 동의 [필수]")
      /// 내용보기
      internal static let seecontent = L10n.tr("Localizable", "SignUp.agree.seecontent", fallback: "내용보기")
      /// 서비스 이용 약관 동의 [필수]
      internal static let service = L10n.tr("Localizable", "SignUp.agree.service", fallback: "서비스 이용 약관 동의 [필수]")
      /// 약관 동의
      internal static let title = L10n.tr("Localizable", "SignUp.agree.title", fallback: "약관 동의")
      /// 만 14세 이상입니다. [필수]
      internal static let year14 = L10n.tr("Localizable", "SignUp.agree.year14", fallback: "만 14세 이상입니다. [필수]")
    }
    internal enum Birth {
      /// 생년월일을 올바르게 입력해주세요.
      internal static let guidelabel = L10n.tr("Localizable", "SignUp.birth.guidelabel", fallback: "생년월일을 올바르게 입력해주세요.")
      /// 생년월일 8자를 입력해주세요.
      internal static let placeholder = L10n.tr("Localizable", "SignUp.birth.placeholder", fallback: "생년월일 8자를 입력해주세요.")
      /// 생년월일(선택)
      internal static let title = L10n.tr("Localizable", "SignUp.birth.title", fallback: "생년월일(선택)")
    }
    internal enum Code {
      /// 인증번호를 다시 입력해주세요.
      internal static let guidelabel = L10n.tr("Localizable", "SignUp.code.guidelabel", fallback: "인증번호를 다시 입력해주세요.")
      /// 인증번호 6자리
      internal static let placeholder = L10n.tr("Localizable", "SignUp.code.placeholder", fallback: "인증번호 6자리")
      /// 인증번호
      internal static let title = L10n.tr("Localizable", "SignUp.code.title", fallback: "인증번호")
      internal enum Correct {
        /// 인증이 완료되었습니다.
        internal static let guidelabel = L10n.tr("Localizable", "SignUp.code.correct.guidelabel", fallback: "인증이 완료되었습니다.")
      }
    }
    internal enum Email {
      /// 이메일을 입력해주세요.
      internal static let placeholder = L10n.tr("Localizable", "SignUp.email.placeholder", fallback: "이메일을 입력해주세요.")
      /// 이메일
      internal static let title = L10n.tr("Localizable", "SignUp.email.title", fallback: "이메일")
      internal enum Guidelabel {
        /// 이미 존재하는 이메일입니다.
        internal static let exist = L10n.tr("Localizable", "SignUp.email.guidelabel.exist", fallback: "이미 존재하는 이메일입니다.")
        /// 이메일 형식이 아닙니다.
        internal static let notemail = L10n.tr("Localizable", "SignUp.email.guidelabel.notemail", fallback: "이메일 형식이 아닙니다.")
        /// 이메일 길이를 초과하였습니다.
        internal static let toolong = L10n.tr("Localizable", "SignUp.email.guidelabel.toolong", fallback: "이메일 길이를 초과하였습니다.")
      }
    }
    internal enum Gender {
      /// 남자
      internal static let man = L10n.tr("Localizable", "SignUp.gender.man", fallback: "남자")
      /// 성별(선택)
      internal static let title = L10n.tr("Localizable", "SignUp.gender.title", fallback: "성별(선택)")
      /// 여자
      internal static let woman = L10n.tr("Localizable", "SignUp.gender.woman", fallback: "여자")
    }
    internal enum Job {
      /// 직업을 선택해주세요.
      internal static let placeholder = L10n.tr("Localizable", "SignUp.job.placeholder", fallback: "직업을 선택해주세요.")
      /// 직업(선택)
      internal static let title = L10n.tr("Localizable", "SignUp.job.title", fallback: "직업(선택)")
    }
    internal enum Nickname {
      /// 중복확인
      internal static let checkDuplicate = L10n.tr("Localizable", "SignUp.nickname.checkDuplicate", fallback: "중복확인")
      /// 10글자 이내로 작성해주세요.
      internal static let placeholder = L10n.tr("Localizable", "SignUp.nickname.placeholder", fallback: "10글자 이내로 작성해주세요.")
      /// 닉네임
      internal static let title = L10n.tr("Localizable", "SignUp.nickname.title", fallback: "닉네임")
      internal enum Guidelabel {
        /// 이미 존재하는 닉네임입니다.
        internal static let exist = L10n.tr("Localizable", "SignUp.nickname.guidelabel.exist", fallback: "이미 존재하는 닉네임입니다.")
        /// 사용 가능한 닉네임입니다.
        internal static let valid = L10n.tr("Localizable", "SignUp.nickname.guidelabel.valid", fallback: "사용 가능한 닉네임입니다.")
      }
    }
    internal enum Password {
      /// 영문, 특수문자를 포함한 8자리 이상, 20자리 이하로 입력해주세요.
      internal static let guidelabel = L10n.tr("Localizable", "SignUp.password.guidelabel", fallback: "영문, 특수문자를 포함한 8자리 이상, 20자리 이하로 입력해주세요.")
      /// 영문, 특수문자를 포함한 8 - 20자리 이하
      internal static let placeholder = L10n.tr("Localizable", "SignUp.password.placeholder", fallback: "영문, 특수문자를 포함한 8 - 20자리 이하")
      /// 비밀번호
      internal static let title = L10n.tr("Localizable", "SignUp.password.title", fallback: "비밀번호")
    }
    internal enum Passwordconfirm {
      /// 입력하신 비밀번호와 일치하지 않습니다.
      internal static let guidelabel = L10n.tr("Localizable", "SignUp.passwordconfirm.guidelabel", fallback: "입력하신 비밀번호와 일치하지 않습니다.")
      /// 비밀번호를 한 번 더 입력해주세요.
      internal static let placeholder = L10n.tr("Localizable", "SignUp.passwordconfirm.placeholder", fallback: "비밀번호를 한 번 더 입력해주세요.")
      /// 비밀번호 확인
      internal static let title = L10n.tr("Localizable", "SignUp.passwordconfirm.title", fallback: "비밀번호 확인")
    }
    internal enum Phone {
      /// 이미 등록된 휴대폰 번호입니다.
      internal static let guidelabel = L10n.tr("Localizable", "SignUp.phone.guidelabel", fallback: "이미 등록된 휴대폰 번호입니다.")
      /// 숫자만 입력해주세요.
      internal static let placeholder = L10n.tr("Localizable", "SignUp.phone.placeholder", fallback: "숫자만 입력해주세요.")
      /// 재발송
      internal static let resendCode = L10n.tr("Localizable", "SignUp.phone.resendCode", fallback: "재발송")
      /// 인증번호 발송
      internal static let sendCode = L10n.tr("Localizable", "SignUp.phone.sendCode", fallback: "인증번호 발송")
      /// 휴대폰 번호
      internal static let title = L10n.tr("Localizable", "SignUp.phone.title", fallback: "휴대폰 번호")
    }
  }
  internal enum Start {
    /// 시작하기
    internal static let title = L10n.tr("Localizable", "Start.title", fallback: "시작하기")
  }
  internal enum Tutorial {
    internal enum First {
      /// 회고를 해보기 전에 회고의 의미를 먼저
      /// 알아볼까요?
      /// 
      /// 회고의 사전적 정의는
      /// 지나간 일을 돌이켜 생각함이에요!
      /// 
      /// 우리가 어릴 때부터 작성했던 일기는 단순히 기록의 목적만을 가지고 있기에 회고와는 분명히 차이가 있어요!
      internal static let description = L10n.tr("Localizable", "Tutorial.First.description", fallback: "회고를 해보기 전에 회고의 의미를 먼저\n알아볼까요?\n\n회고의 사전적 정의는\n지나간 일을 돌이켜 생각함이에요!\n\n우리가 어릴 때부터 작성했던 일기는 단순히 기록의 목적만을 가지고 있기에 회고와는 분명히 차이가 있어요!")
      /// 회고가 처음이시라구요?
      internal static let title = L10n.tr("Localizable", "Tutorial.First.Title", fallback: "회고가 처음이시라구요?")
    }
    internal enum Second {
      /// 회고를 함으로써 크고 작은 목표를 달성하기까지
      /// 잘한 점과 아쉬운 점 그리고 지켜봐야 할 점을
      /// 찾아내고 이를 기반으로 개선을 위한 아이디어와
      /// 구체적인 실행 방안을 도출할 수 있습니다.
      /// 
      /// 즉 어제보다 더 나은 내일을 만들어 나갈 수 있는
      /// 것이죠!
      /// 
      /// 회고의 의미와 해야 되는 이유를 알았으니
      /// 그로우립 사용할 준비가 완료되었습니다!
      internal static let description = L10n.tr("Localizable", "Tutorial.Second.description", fallback: "회고를 함으로써 크고 작은 목표를 달성하기까지\n잘한 점과 아쉬운 점 그리고 지켜봐야 할 점을\n찾아내고 이를 기반으로 개선을 위한 아이디어와\n구체적인 실행 방안을 도출할 수 있습니다.\n\n즉 어제보다 더 나은 내일을 만들어 나갈 수 있는\n것이죠!\n\n회고의 의미와 해야 되는 이유를 알았으니\n그로우립 사용할 준비가 완료되었습니다!")
      /// 회고를 해야 되는 이유는요!
      internal static let title = L10n.tr("Localizable", "Tutorial.Second.Title", fallback: "회고를 해야 되는 이유는요!")
    }
  }
  internal enum WriteRetrospect {
    /// 회고 작성
    internal static let title = L10n.tr("Localizable", "WriteRetrospect.title", fallback: "회고 작성")
    internal enum Modal {
      internal enum Tutorial {
        /// 회고 작성하는 법
        internal static let title = L10n.tr("Localizable", "WriteRetrospect.Modal.Tutorial.title", fallback: "회고 작성하는 법")
        internal enum Skip {
          internal enum Button {
            /// SKIP
            internal static let title = L10n.tr("Localizable", "WriteRetrospect.Modal.Tutorial.Skip.button.title", fallback: "SKIP")
          }
        }
        internal enum Final {
          /// +버튼을 통해 회고를 추가할 수 있습니다.
          internal static let description = L10n.tr("Localizable", "WriteRetrospect.Modal.Tutorial.final.description", fallback: "+버튼을 통해 회고를 추가할 수 있습니다.")
        }
        internal enum First {
          /// 회고를 하기 위해서는 총 4가지를 입력 해야 해요!
          /// 첫 번째는 회고 하고 싶은 내용을 DONE에 입력합니다.
          internal static let description = L10n.tr("Localizable", "WriteRetrospect.Modal.Tutorial.first.description", fallback: "회고를 하기 위해서는 총 4가지를 입력 해야 해요!\n첫 번째는 회고 하고 싶은 내용을 DONE에 입력합니다.")
        }
        internal enum Fourth {
          /// DONE에 대해 잘하고 있는 것을 더 잘할 수 있는 것, 당장 시도해 볼 내용을 TRY에 입력합니다.
          internal static let description = L10n.tr("Localizable", "WriteRetrospect.Modal.Tutorial.fourth.description", fallback: "DONE에 대해 잘하고 있는 것을 더 잘할 수 있는 것, 당장 시도해 볼 내용을 TRY에 입력합니다.")
        }
        internal enum Second {
          /// DONE에 대해 만족하는 것, 계속 유지하고 싶은 내용을
          /// KEEP에 입력합니다.
          internal static let description = L10n.tr("Localizable", "WriteRetrospect.Modal.Tutorial.second.description", fallback: "DONE에 대해 만족하는 것, 계속 유지하고 싶은 내용을\nKEEP에 입력합니다.")
        }
        internal enum Third {
          /// DONE에 대해 불편하게 느끼는 부분으로 개선이 필요하다고 생각되는 내용을 PROBELM에 입력합니다.
          internal static let description = L10n.tr("Localizable", "WriteRetrospect.Modal.Tutorial.third.description", fallback: "DONE에 대해 불편하게 느끼는 부분으로 개선이 필요하다고 생각되는 내용을 PROBELM에 입력합니다.")
        }
      }
      internal enum NotYet {
        /// ❗️
        internal static let emoji = L10n.tr("Localizable", "WriteRetrospect.Modal.notYet.emoji", fallback: "❗️")
        /// 작성 중인 글이 저장되지 않았습니다.
        /// 그래도 돌아가시겠어요?
        internal static let title = L10n.tr("Localizable", "WriteRetrospect.Modal.notYet.title", fallback: "작성 중인 글이 저장되지 않았습니다.\n그래도 돌아가시겠어요?")
      }
    }
    internal enum Done {
      /// DONE
      internal static let title = L10n.tr("Localizable", "WriteRetrospect.done.title", fallback: "DONE")
    }
    internal enum Enroll {
      internal enum Button {
        /// 등록하기
        internal static let title = L10n.tr("Localizable", "WriteRetrospect.enroll.button.title", fallback: "등록하기")
      }
    }
    internal enum Keep {
      /// KEEP
      internal static let title = L10n.tr("Localizable", "WriteRetrospect.keep.title", fallback: "KEEP")
    }
    internal enum Problem {
      /// PROBLEM
      internal static let title = L10n.tr("Localizable", "WriteRetrospect.problem.title", fallback: "PROBLEM")
    }
    internal enum Try {
      /// TRY
      internal static let title = L10n.tr("Localizable", "WriteRetrospect.try.title", fallback: "TRY")
    }
  }
  internal enum Yes {
    /// 예
    internal static let title = L10n.tr("Localizable", "Yes.title", fallback: "예")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
