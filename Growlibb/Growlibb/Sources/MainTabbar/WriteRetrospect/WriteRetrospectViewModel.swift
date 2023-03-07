//
//  WriteRetrospectViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/15.
//

import Foundation
import RxSwift
import RxRelay

final class WriteRetrospectViewModel: BaseViewModel {
    
    var doneCount = 1
    var keepCount = 1
    var problemCount = 1
    var tryCount = 1

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        writeRetrospectAPIService: WriteRetrospectAPIService = WriteRetrospectAPIService()
    ) {
        super.init()
        
        inputs.showTutorial
            .subscribe(routes.showTutorial)
            .disposed(by: disposeBag)
        
        inputs.backward
            .subscribe(onNext: { empty in
                self.routes.backward.onNext(empty)
            })
            .disposed(by: disposeBag)
        
        inputs.addDone
            .subscribe(onNext: { _ in
                var sections = self.outputs.doneList.value
                self.doneCount += 1
                sections[0].items.append("done \(self.doneCount)")
                self.outputs.doneList.accept(sections)
            })
            .disposed(by: disposeBag)
        
        
        inputs.deleteDone
            .subscribe(onNext: { index in
                var sections = self.outputs.doneList.value
                self.doneCount += 1 //duplicate item 이슈 방지
                sections[0].items.remove(at: index)
                self.outputs.doneList.accept(sections)
            })
            .disposed(by: disposeBag)
        
        inputs.addKeep
            .subscribe(onNext: { _ in
                var sections = self.outputs.keepList.value
                self.keepCount += 1
                sections[0].items.append("keep \(self.keepCount)")
                self.outputs.keepList.accept(sections)
            })
            .disposed(by: disposeBag)
        
        
        inputs.deleteKeep
            .subscribe(onNext: { index in
                var sections = self.outputs.keepList.value
                self.keepCount += 1
                sections[0].items.remove(at: index)
                self.outputs.keepList.accept(sections)
            })
            .disposed(by: disposeBag)
        
        inputs.addProblem
            .subscribe(onNext: { _ in
                var sections = self.outputs.problemList.value
                self.problemCount += 1
                sections[0].items.append("problem \(self.problemCount)")
                self.outputs.problemList.accept(sections)
            })
            .disposed(by: disposeBag)
        
        
        inputs.deleteProblem
            .subscribe(onNext: { index in
                var sections = self.outputs.problemList.value
                self.problemCount += 1
                sections[0].items.remove(at: index)
                self.outputs.problemList.accept(sections)
            })
            .disposed(by: disposeBag)
        
        inputs.addTry
            .subscribe(onNext: { _ in
                var sections = self.outputs.tryList.value
                self.tryCount += 1
                sections[0].items.append("try \(self.tryCount)")
                self.outputs.tryList.accept(sections)
            })
            .disposed(by: disposeBag)
        
        
        inputs.deleteTry
            .subscribe(onNext: { index in
                var sections = self.outputs.tryList.value
                self.tryCount += 1
                sections[0].items.remove(at: index)
                self.outputs.tryList.accept(sections)
            })
            .disposed(by: disposeBag)
        
        inputs.complete
            .flatMap { writeRetrospectAPIService.postRetrospect(request: $0) }
            .subscribe(onNext: { [ weak self] result in
                switch result {
                case .response(result: _):
                    self?.routes.completed.onNext(())
                    self?.toast.onNext("오늘의 회고 작성이 완료되었습니다.")
                case .error(alertMessage: let alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Bool>() //내용이 다 비어있는지, 하나라도 차있는지 판단 필요
        var showTutorial = PublishSubject<Void>()
        var addDone = PublishSubject<Void>()
        var addKeep = PublishSubject<Void>()
        var addProblem = PublishSubject<Void>()
        var addTry = PublishSubject<Void>()
        var deleteDone = PublishSubject<Int>()
        var deleteKeep = PublishSubject<Int>()
        var deleteProblem = PublishSubject<Int>()
        var deleteTry = PublishSubject<Int>()
        var complete = PublishSubject<PostRetrospectRequest>()
    }

    struct Output {
        var doneList = BehaviorRelay(value: [WriteRetrospectSection(items: [""])]) //초기값이 있는 mutating한 item
        var keepList = BehaviorRelay(value: [WriteRetrospectSection(items: [""])])
        var problemList = BehaviorRelay(value: [WriteRetrospectSection(items: [""])])
        var tryList = BehaviorRelay(value: [WriteRetrospectSection(items: [""])])
    }

    struct Route {
        var backward = PublishSubject<Bool>()
        var showTutorial = PublishSubject<Void>()
        var completed = PublishSubject<Void>()
    }

    struct RouteInput {
//        var needUpdate = PublishSubject<Bool>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
