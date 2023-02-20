//
//  EditRetrospectViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import Foundation
import RxSwift

final class EditRetrospectViewModel: BaseViewModel {
    
    var doneCount = 1
    var keepCount = 1
    var problemCount = 1
    var tryCount = 1

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
                    self!.outputs.doneList.onNext(result!.done)
                    self!.outputs.keepList.onNext(result!.keep)
                    self!.outputs.problemList.onNext(result!.problem)
                    self!.outputs.tryList.onNext(result!.attempt)
                    
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        inputs.complete
            .flatMap { myPageAPIService.patchRetrospect(request: $0)}
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(result: result):
                    if result!.isSuccess {
                        self?.toast.onNext("회고 수정이 완료되었습니다.")
                        self?.inputs.backward.onNext(())
                    }else{
                        self?.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
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
        
        inputs.addDone
            .subscribe(onNext: { _ in
                self.doneCount += 1
                self.outputs.doneList.onNext([Attempt(content:"")])
            })
            .disposed(by: disposeBag)
        
        inputs.addKeep
            .subscribe(onNext: { _ in
                self.keepCount += 1
                self.outputs.keepList.onNext([Attempt(content:"")])
            })
            .disposed(by: disposeBag)
        
        inputs.addTry
            .subscribe(onNext: { _ in
                self.tryCount += 1
                self.outputs.tryList.onNext([Attempt(content:"")])
            })
            .disposed(by: disposeBag)
        
        inputs.addProblem
            .subscribe(onNext: { _ in
                self.problemCount += 1
                self.outputs.problemList.onNext([Attempt(content:"")])
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var addDone = PublishSubject<Void>()
        var addKeep = PublishSubject<Void>()
        var addProblem = PublishSubject<Void>()
        var addTry = PublishSubject<Void>()
        var deleteDone = PublishSubject<Int>()
        var deleteKeep = PublishSubject<Int>()
        var deleteProblem = PublishSubject<Int>()
        var deleteTry = PublishSubject<Int>()
        var complete = PublishSubject<PatchRetrospectRequest>()
    }

    struct Output {
        var writtenDate = PublishSubject<String>()
        var doneList = PublishSubject<[Attempt]>()
        var keepList = PublishSubject<[Attempt]>()
        var problemList = PublishSubject<[Attempt]>()
        var tryList = PublishSubject<[Attempt]>()
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var edited = PublishSubject<Void>()
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
