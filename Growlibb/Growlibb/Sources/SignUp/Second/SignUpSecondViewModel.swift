//
//  SignUpSecondViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/21.
//

import Foundation
import RxSwift

final class SignUpSecondViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapNext
            .subscribe(routes.next)
            .disposed(by: disposeBag)
        
        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        var tapNext = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()
    }

    struct Output {
    }

    struct Route {
        var next = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    var inputs = Input()
    var outputs = Output()
    var routes = Route()

    // MARK: Private

    private var disposeBag = DisposeBag()
}
