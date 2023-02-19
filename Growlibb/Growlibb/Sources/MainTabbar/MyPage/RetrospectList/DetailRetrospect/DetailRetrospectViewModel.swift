//
//  DetailRetrospectViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import Foundation
import RxSwift

final class DetailRetrospectViewModel: BaseViewModel {

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        myPageAPIService: MyPageAPIService = MyPageAPIService(),
        retrospectionId: Int
    ) {
        super.init()
        
        routeInputs.needUpdate
            .flatMap { _ in myPageAPIService.getDetailRetrospect(retrospectionId: retrospectionId) }
            .subscribe(onNext: { [weak self] result in
                print(result)
                switch result {
                case let .response(result: result):
                    self?.outputs.writtenDate.onNext(result!.writtenDate)
                    self?.outputs.doneList.onNext(result!.done)
                    self?.outputs.keepList.onNext(result!.keep)
                    self?.outputs.problemList.onNext(result!.problem)
                    self?.outputs.tryList.onNext(result!.attempt)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        inputs.modify
            .bind(to: routes.modify)
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var modify = PublishSubject<Int>()
    }

    struct Output {
        var writtenDate = PublishSubject<String>()
        var doneList = ReplaySubject<[Attempt]>.create(bufferSize: 1)
        var keepList = ReplaySubject<[Attempt]>.create(bufferSize: 1)
        var problemList = ReplaySubject<[Attempt]>.create(bufferSize: 1)
        var tryList = ReplaySubject<[Attempt]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var modify = PublishSubject<Int>()
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
