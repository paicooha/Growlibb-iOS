//
//  EditNotiViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/06.
//

import RxSwift

final class EditNotiViewModel: BaseViewModel {
    

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared)
    {
        super.init()
        
        routeInputs.needUpdate
            .subscribe(onNext: { _ in
//                self.outputs.csList.onNext(self.csList)
            })
            .disposed(by: disposeBag)
        
        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
        
    }

    struct Input {
        var backward = PublishSubject<Void>()
    }

    struct Output {

    }

    struct Route {
        var backward = PublishSubject<Void>()
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
