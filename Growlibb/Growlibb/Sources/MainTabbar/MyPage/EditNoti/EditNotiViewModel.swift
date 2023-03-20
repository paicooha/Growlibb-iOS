//
//  EditNotiViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/06.
//

import RxSwift
import FirebaseMessaging

final class EditNotiViewModel: BaseViewModel {
    
    var fcmToken:String? = nil
    var userKeyChainService: UserKeychainService

    init(
        userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared,
        myPageAPIService: MyPageAPIService = MyPageAPIService()
    ) {
        self.userKeyChainService = userKeyChainService
        super.init()

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
        
        inputs.pushSwitch
            .do(onNext: { [self] token in
                if token != nil {
                    self.fcmToken = token
                }
                else{
                    self.fcmToken = nil
                }
            })
            .flatMap { token in
                myPageAPIService.patchAlarm(fcmToken: self.fcmToken)
            }
            .subscribe(onNext: { result in
                switch result {
                case .response(result: _):
                    if self.fcmToken == nil {
                        self.userKeyChainService.fcmToken = ""
                    }
                    else{
                        self.userKeyChainService.fcmToken = Messaging.messaging().fcmToken ?? ""
                    }
                    print(userKeyChainService.fcmToken)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        }

    struct Input {
        var backward = PublishSubject<Void>()
        var pushSwitch = PublishSubject<String?>()
    }

    struct Output {
        
    }

    struct Route {
        var backward = PublishSubject<Void>()
    }

    struct RouteInput {
        
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
