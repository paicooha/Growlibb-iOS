//
//  LoginVoewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import Foundation
import RxSwift

final class LoginViewModel: BaseViewModel {
    private var userKeyChainService: UserKeychainService

    // MARK: Lifecycle

    init(userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared) {
        self.userKeyChainService = userKeyChainService
        super.init()

        inputs.loginSuccess
            .bind(to: routes.loginSuccess)
            .disposed(by: disposeBag)
        
        inputs.goToSignup
            .subscribe(routes.goToSignup)
            .disposed(by: disposeBag)
        
    }

    // MARK: Internal

    struct Input {
        let loginSuccess = PublishSubject<Void>()
        let loginFail = PublishSubject<Void>()
        let goToSignup = PublishSubject<Void>()
    }

    struct Output {
        let loginFail = PublishSubject<Void>()
    }

    struct Route {
        let loginSuccess = PublishSubject<Void>()
        let goToSignup = PublishSubject<Void>()
    }

    let disposeBag = DisposeBag()
    let inputs = Input()
    let outputs = Output()
    let routes = Route()
}

