//
//  BasicUserKeyChainServic.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation
import SwiftKeychainWrapper

final class BasicUserKeyChainService: UserKeychainService {
    static let shared = BasicUserKeyChainService()

    private init(keychainWrapper: KeychainWrapper = .standard) {
        self.keychainWrapper = keychainWrapper
    }

    let keychainWrapper: KeychainWrapper

    var fcmToken: String {
        get {
            guard let deviceToken: String = keychainWrapper[.User.fcmToken]
            else {
                Log.d(tag: .info, "get deviceToken: nil")
                return ""
            }
            Log.d(tag: .info, "get deviceToken: \(deviceToken)")
            return deviceToken
        }

        set {
            Log.d(tag: .info, "set deviceToken: \(newValue )")
            keychainWrapper.remove(forKey: .User.fcmToken)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.fcmToken.rawValue)
        }
    }

    var nickName: String {
        get {
            guard let nickName: String = keychainWrapper[.User.nickName]
            else {
                Log.d(tag: .info, "get nickName: \"\"")
                return ""
            }
            Log.d(tag: .info, "get nickName: \(nickName)")
            return nickName
        }
        set {
            Log.d(tag: .info, "set nickName: \(newValue )")
            keychainWrapper.remove(forKey: .User.nickName)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.nickName.rawValue)
        }
    }
    
    
    var level: Int {
        get {
            guard let level: Int = keychainWrapper[.User.level]
            else {
                Log.d(tag: .info, "get level: \"\"")
                return 0
            }
            Log.d(tag: .info, "get level: \(level)")
            return level
        }
        set {
            Log.d(tag: .info, "set level: \(newValue )")
            keychainWrapper.remove(forKey: .User.level)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.level.rawValue)
        }
    }

    func clear() {
        nickName = ""
        fcmToken = ""
    }
}

private extension KeychainWrapper.Key {
    enum User {
        static let fcmToken: KeychainWrapper.Key = "User.fcmToken"
        static let nickName: KeychainWrapper.Key = "SingupInfo.NickName"
        static let level: KeychainWrapper.Key = "User.level"
    }
}
