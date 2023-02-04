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
            .subscribe(onNext: { whereFrom in
                switch whereFrom {
                case "writeretrospect":
                    self.routes.backward.onNext(())
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        inputs.no
            .bind(to: routes.close)
            .disposed(by: disposeBag)
    }

    struct Input {
        var no = PublishSubject<Void>()
        var yes = PublishSubject<String>()
    }

    struct Output {

    }

    struct Route {
        var close = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    struct RouteInput {
//        var filterChanged = PublishSubject<PostFilter>()
//        var detailClosed = PublishSubject<Void>()
//        var postListOrderChanged = PublishSubject<PostListOrder>()
//        var runningTagChanged = PublishSubject<RunningTag>()
//        var alarmChecked = PublishSubject<Void>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
