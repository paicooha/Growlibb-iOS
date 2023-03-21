//
//  ViewRetrospectViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation
import RxSwift

final class RetrospectListViewModel: BaseViewModel {
    
    private var currentPage = 1

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        myPageAPIService: MyPageAPIService = MyPageAPIService()
    ) {
        super.init()
        
        routeInputs.needUpdate
            .flatMap { _ in myPageAPIService.getRetrospectList(page: self.currentPage) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(result: result):
                    if result != nil {
                        self?.currentPage += 1
                        self?.outputs.retrospectList.onNext(result!.retrospections)
                    }
                    else{
                        self?.outputs.retrospectList.onNext(nil)
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
        
        inputs.goDetail
            .bind(to: routes.goDetail)
            .disposed(by: disposeBag)
    }

    struct Input {
        var goDetail = PublishSubject<Int>()
        var backward = PublishSubject<Void>()
    }

    struct Output {
        var retrospectList = PublishSubject<[Retrospection]?>()

    }

    struct Route {
        var goDetail = PublishSubject<Int>()
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
