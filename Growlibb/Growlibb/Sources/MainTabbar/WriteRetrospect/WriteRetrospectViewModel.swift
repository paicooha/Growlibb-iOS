//
//  WriteRetrospectViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/15.
//

import Foundation
import RxSwift

final class WriteRetrospectViewModel: BaseViewModel {
    
    var doneCount = 1
    var keepCount = 1
    var problemCount = 1
    var tryCount = 1

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared
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
        
        routeInputs.needUpdate
            .subscribe(onNext: { _ in
                self.outputs.doneList.onNext([WriteRetrospectSection(items: [""])])
                self.outputs.keepList.onNext([WriteRetrospectSection(items: [""])])
                self.outputs.problemList.onNext([WriteRetrospectSection(items: [""])])
                self.outputs.tryList.onNext([WriteRetrospectSection(items: [""])])
            })
            .disposed(by: disposeBag)
        
        inputs.addDone
            .subscribe(onNext: { _ in
                guard var sections = try? self.outputs.doneList.value() else { return }
                self.doneCount += 1
                sections[0].items.append("\(self.doneCount)")
                self.outputs.doneList.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        
        inputs.deleteDone
            .subscribe(onNext: { [weak self] index in
                guard var sections = try? self!.outputs.doneList.value() else { return }
                self!.doneCount -= 1
                sections[0].items.remove(at: index)
                self!.outputs.doneList.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        inputs.addKeep
            .subscribe(onNext: { _ in
                guard var sections = try? self.outputs.keepList.value() else { return }
                self.keepCount += 1
                sections[0].items.append("\(self.keepCount)")
                self.outputs.keepList.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        
        inputs.deleteKeep
            .subscribe(onNext: { [weak self] index in
                guard var sections = try? self!.outputs.keepList.value() else { return }
                self!.keepCount -= 1
                sections[0].items.remove(at: index)
                self!.outputs.keepList.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        inputs.addProblem
            .subscribe(onNext: { _ in
                guard var sections = try? self.outputs.problemList.value() else { return }
                self.problemCount += 1
                sections[0].items.append("\(self.problemCount)")
                self.outputs.problemList.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        
        inputs.deleteProblem
            .subscribe(onNext: { [weak self] index in
                guard var sections = try? self!.outputs.problemList.value() else { return }
                self!.problemCount -= 1
                sections[0].items.remove(at: index)
                self!.outputs.problemList.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        inputs.addTry
            .subscribe(onNext: { _ in
                guard var sections = try? self.outputs.tryList.value() else { return }
                self.tryCount += 1
                sections[0].items.append("\(self.tryCount)")
                self.outputs.tryList.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        
        inputs.deleteTry
            .subscribe(onNext: { [weak self] index in
                guard var sections = try? self!.outputs.tryList.value() else { return }
                self!.tryCount -= 1
                sections[0].items.remove(at: index)
                self!.outputs.tryList.onNext(sections)
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
        var doneList = BehaviorSubject(value: [WriteRetrospectSection(items: [""])])
        var keepList = BehaviorSubject(value: [WriteRetrospectSection(items: [""])])
        var problemList = BehaviorSubject(value: [WriteRetrospectSection(items: [""])])
        var tryList = BehaviorSubject(value: [WriteRetrospectSection(items: [""])])
    }

    struct Route {
        var backward = PublishSubject<Bool>()
        var showTutorial = PublishSubject<Void>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
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
