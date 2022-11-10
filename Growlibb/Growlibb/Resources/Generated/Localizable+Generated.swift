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
