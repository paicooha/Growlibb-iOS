//
//  LoginKeyChainService.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import Foundation

protocol LoginKeyChainService {
    var token: LoginToken? { get set }
    var userId: Int? { get set }
    var loginType: LoginType { get set }

    func setLoginInfo(loginType: LoginType, userID: Int?, token: LoginToken?)
    func clearIfFirstLaunched()
    func clear()
}
