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
        
        inputs.detailRetrospect
            .bind(to: routes.detailRetrospect)
            .disposed(by: disposeBag)
    }

    struct Input {
        var writeretrospect = PublishSubject<Void>()
        var detailRetrospect = PublishSubject<Int>()
    }

    struct Output {
        
    }

    struct Route {
        var writeretrospect = PublishSubject<Void>()
        var detailRetrospect = PublishSubject<Int>()
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
