//
//  FindEmailorPasswordViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/29.
//

import Foundation
import RxSwift

final class FindEmailorPasswordViewModel: BaseViewModel {

    // MARK: Lifecycle

    override init() {
        super.init()

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)
        
        inputs.login
            .subscribe(routes.login)
            .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        var tapBackward = PublishSubject<Void>()
        var login = PublishSubject<Void>()
    }

    struct Output {
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var login = PublishSubject<Void>()
    }

    let disposeBag = DisposeBag()
    let inputs = Input()
    let outputs = Output()
    let routes = Route()
}
