//
//  EditPhoneNumberViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
//

import Foundation
import RxSwift

final class EditPhoneNumberViewModel: BaseViewModel {

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        myPageAPIService: MyPageAPIService = MyPageAPIService()
    ) {
        super.init()
        

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
        
        inputs.newPhone
            .flatMap { myPageAPIService.patchPhoneNumber(request: PostCheckPhoneRequest(phoneNumber: $0))}
            .subscribe(onNext: { result in
                switch result {
                case let .response(result: result):
                    switch result!.code {
                    case 2022:
                        self.toast.onNext("이미 사용중인 휴대폰 번호입니다. 다른 번호로 시도해주세요.")
                    case 1000:
                        self.toast.onNext("휴대폰번호 변경이 완료되었습니다.")
                        self.routes.backward.onNext(())
                    default:
                        break
                    }
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
        var newPhone = PublishSubject<String>()
        var backward = PublishSubject<Void>()
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
