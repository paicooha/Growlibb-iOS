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
