//
//  RetrospectViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation
import RxSwift

final class RetrospectViewModel: BaseViewModel {
    var retrospectInfo: RetrospectInfo?
    
    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        retrospectAPIService: RetrospectAPIService = RetrospectAPIService()
    ) {
        super.init()
        
        routeInputs.needUpdate
            .flatMap { _ in
                retrospectAPIService.getRetrospectTab()
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(result: result):
                    self?.outputs.retrospectInfo.onNext(result!)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("데이터 불러오기에 실패했습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        inputs.writeretrospect
            .subscribe(onNext: { [self] id in
                if id == 0 {
                    routes.writeretrospect.onNext(())
                }
                else{
                    routes.editRetrospect.onNext(id)
                }
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var writeretrospect = PublishSubject<Int>()
    }

    struct Output {
        var retrospectInfo = ReplaySubject<RetrospectInfo>.create(bufferSize: 1)
    }

    struct Route {
        var writeretrospect = PublishSubject<Void>()
        var editRetrospect = PublishSubject<Int>()
        var eventShowModal = PublishSubject<(Int, Int)>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
        var backFromWriteretrospect = PublishSubject<Void>()

    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
