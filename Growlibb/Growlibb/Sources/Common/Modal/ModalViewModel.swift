//
//  ModalViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/01.
//

import UIKit
import RxSwift

enum ModalKind {
    case writeretrospect
    case retrospect
    case logout
    case resign
    case event
}

final class ModalViewModel: BaseViewModel{
    override init() {
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

    struct Route {
        var close = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var routes = Route()
}
