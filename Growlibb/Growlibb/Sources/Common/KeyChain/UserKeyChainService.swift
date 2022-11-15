//
//  UserKeyChainService.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation

protocol UserKeychainService {
    var fcmToken: String { get set }
    var nickName: String { get set }

    func clear()
}
