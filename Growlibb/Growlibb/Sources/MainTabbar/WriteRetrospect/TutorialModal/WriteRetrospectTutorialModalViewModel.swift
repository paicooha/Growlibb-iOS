//
//  WriteRetrospectTutorialModalViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/25.
//

import Foundation
import RxSwift

final class WriteRetrospectTutorialViewModel: BaseViewModel {

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared
    ) {
        inputs.close
            .subscribe(routes.close)
            .disposed(by: disposeBag)
    }

    struct Input {
        var close = PublishSubject<Void>()

    }

    struct Output {

    }

    struct Route {

        var close = PublishSubject<Void>()
    }

    struct RouteInput {

    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
