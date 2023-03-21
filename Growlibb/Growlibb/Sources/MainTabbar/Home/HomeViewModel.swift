//
//  HomeViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation
import RxSwift

final class HomeViewModel: BaseViewModel {

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared
    ) {
        
        inputs.writeretrospect
            .bind(to: routes.writeretrospect)
            .disposed(by: disposeBag)
    }

    struct Input {
        var writeretrospect = PublishSubject<Void>()
    }

    struct Output {
        
    }

    struct Route {
        var writeretrospect = PublishSubject<Void>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
