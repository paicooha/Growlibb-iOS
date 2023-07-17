//
//  CSViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation
import RxSwift

final class CSViewModel: BaseViewModel {
    
    var csList = [L10n.MyPage.Cs.noti, L10n.MyPage.Cs.faq, L10n.MyPage.Cs.yakgwan, L10n.MyPage.Cs.privacy]
    
    var doneCount = 1
    var keepCount = 1
    var problemCount = 1
    var tryCount = 1

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared)
    {
        super.init()
        
        routeInputs.needUpdate
            .subscribe(onNext: { [weak self] _ in
                self?.outputs.csList.onNext(self?.csList ?? [])
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
        var csList = ReplaySubject<[String]>.create(bufferSize: 1)
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
