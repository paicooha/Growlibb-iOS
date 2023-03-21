//
//  ModalViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/01.
//

import UIKit
import RxSwift

final class ModalViewModel: BaseViewModel{
    init(whereFrom: String) {
        super.init()
        
        inputs.yes
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
        
        inputs.no
            .bind(to: routes.close)
            .disposed(by: disposeBag)
    }

    struct Input {
        var no = PublishSubject<Void>()
        var yes = PublishSubject<Void>()
    }

    struct Output {

    }

    struct Route {
        var close = PublishSubject<Void>()
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
