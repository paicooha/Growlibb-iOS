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
  internal enum Job {
    /// 사무관리직
    internal static let des = L10n.tr("Localizable", "Job.DES", fallback: "사무관리직")
    /// 주부
    internal static let hou = L10n.tr("Localizable", "Job.HOU", fallback: "주부")
    /// 기술직(IT/공학계열)
    internal static let it = L10n.tr("Localizable", "Job.IT", fallback: "기술직(IT/공학계열)")
    /// 무직(퇴직자 포함)
    internal static let not = L10n.tr("Localizable", "Job.NOT", fallback: "무직(퇴직자 포함)")
    /// 경찰/소방/군인
    internal static let off = L10n.tr("Localizable", "Job.OFF", fallback: "경찰/소방/군인")
    /// 공무원
    internal static let pub = L10n.tr("Localizable", "Job.PUB", fallback: "공무원")
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
  internal enum Next {
    internal enum Button {
      /// 다음
      internal static let title = L10n.tr("Localizable", "Next.Button.title", fallback: "다음")
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
    }
    internal enum Birth {
      /// 생년월일을 올바르게 입력해주세요.
      internal static let guidelabel = L10n.tr("Localizable", "SignUp.birth.guidelabel", fallback: "생년월일을 올바르게 입력해주세요.")
      /// 생년월일 8자를 입력해주세요.
      internal static let placeholder = L10n.tr("Localizable", "SignUp.birth.placeholder", fallback: "생년월일 8자를 입력해주세요.")
      /// 생년월일
      internal static let title = L10n.tr("Localizable", "SignUp.birth.title", fallback: "생년월일")
    }
    internal enum Code {
      /// 인증번호를 다시 입력해주세요.
      internal static let guidelabel = L10n.tr("Localizable", "SignUp.code.guidelabel", fallback: "인증번호를 다시 입력해주세요.")
      /// 인증번호 6자리
      internal static let placeholder = L10n.tr("Localizable", "SignUp.code.placeholder", fallback: "인증번호 6자리")
      /// 인증번호
      internal static let title = L10n.tr("Localizable", "SignUp.code.title", fallback: "인증번호")
    }
    internal enum Email {
      /// 이메일을 입력해주세요.
      internal static let placeholder = L10n.tr("Localizable", "SignUp.email.placeholder", fallback: "이메일을 입력해주세요.")
      /// 이메일
      internal static let title = L10n.tr("Localizable", "SignUp.email.title", fallback: "이메일")
      internal enum Guidelabel {
        /// 이미 존재하는 이메일입니다
        internal static let exist = L10n.tr("Localizable", "SignUp.email.guidelabel.exist", fallback: "이미 존재하는 이메일입니다")
        /// 이메일 형식이 아닙니다.
        internal static let notemail = L10n.tr("Localizable", "SignUp.email.guidelabel.notemail", fallback: "이메일 형식이 아닙니다.")
        /// 이메일 길이를 초과하였습니다.
        internal static let toolong = L10n.tr("Localizable", "SignUp.email.guidelabel.toolong", fallback: "이메일 길이를 초과하였습니다.")
      }
    }
    internal enum Gender {
      /// 남자
      internal static let man = L10n.tr("Localizable", "SignUp.gender.man", fallback: "남자")
      /// 성별
      internal static let title = L10n.tr("Localizable", "SignUp.gender.title", fallback: "성별")
      /// 여자
      internal static let woman = L10n.tr("Localizable", "SignUp.gender.woman", fallback: "여자")
    }
    internal enum Job {
      /// 직업을 선택해주세요.
      internal static let placeholder = L10n.tr("Localizable", "SignUp.job.placeholder", fallback: "직업을 선택해주세요.")
      /// 직업
      internal static let title = L10n.tr("Localizable", "SignUp.job.title", fallback: "직업")
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
      /// 비밀번호 확인
      internal static let title = L10n.tr("Localizable", "SignUp.passwordconfirm.title", fallback: "비밀번호 확인")
    }
    internal enum Phone {
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
