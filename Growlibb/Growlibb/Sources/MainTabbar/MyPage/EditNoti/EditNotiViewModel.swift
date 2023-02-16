//
//  EditNotiViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/06.
//

import RxSwift

final class EditNotiViewModel: BaseViewModel {
    

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        myPageAPIService: MyPageAPIService = MyPageAPIService()
    ) {
        super.init()

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
        
        inputs.pushSwitch
            .flatMap { token in
                myPageAPIService.patchAlarm(request: PatchFcmRequest(fcmToken: token))
            }
            .subscribe(onNext: { result in
                switch result {
                case .response(result: _):
                    break
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
