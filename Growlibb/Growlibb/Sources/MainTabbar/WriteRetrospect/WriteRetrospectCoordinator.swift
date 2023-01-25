//
//  WriteRetrospectCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/15.
//

import Foundation
import RxSwift
import UIKit

enum WriteRetrospectResult {
    case backward
}

final class WriteRetrospectCoordinator: BasicCoordinator<WriteRetrospectResult> {
    // MARK: Lifecycle

    init(component: WriteRetrospectComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: WriteRetrospectComponent

    override func start(animated _: Bool = true) { // VM의 route 바인딩
        let scene = component.scene
        
        navigationController.pushViewController(scene.VC, animated: true)
        
        closeSignal
            .subscribe(onNext: { [weak self] result in
                Log.d(tag: .lifeCycle, "VC poped")

                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.backward
            .map { WriteRetrospectResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.showTutorial
            .subscribe(onNext: { [weak self] _ in
                self?.showWriteRetrospectTutorialModal()
            })
            .disposed(by: sceneDisposeBag)
//
//        scene.VM.routes.writingPost
//            .map { scene.VM }
//            .subscribe(onNext: { [weak self] vm in
//                self?.pushWritingPostScene(vm: vm, animated: true)
//            })
//            .disposed(by: sceneDisposeBag)
//
//        scene.VM.routes.detailPost
//            .map { (vm: scene.VM, postId: $0) }
//            .subscribe(onNext: { [weak self] input in
//                self?.pushDetailPostScene(vm: input.vm, postId: input.postId, animated: true)
//            })
//            .disposed(by: sceneDisposeBag)
//
//        scene.VM.routes.nonMemberCover
//            .map { .needCover }
//            .subscribe(closeSignal)
//            .disposed(by: sceneDisposeBag)
//
//        scene.VM.routes.postListOrder
//            .map { scene.VM }
//            .subscribe(onNext: { [weak self] vm in
//                self?.showPostListOrderModal(vm: vm, animated: false)
//            })
//            .disposed(by: sceneDisposeBag)
//
//        scene.VM.routes.runningTag
//            .map { scene.VM }
//            .subscribe(onNext: { [weak self] vm in
//                self?.showRunningTagModal(vm: vm, animated: false)
//            })
//            .disposed(by: sceneDisposeBag)
//
//        scene.VM.routes.alarmList
//            .map { scene.VM }
//            .subscribe(onNext: { [weak self] vm in
//                self?.pushAlarmListScene(vm: vm, animated: true)
//            })
//            .disposed(by: sceneDisposeBag)
    }

    private func showWriteRetrospectTutorialModal() {
        let comp = component.writeRetrospectTutorialModalComponent()
        let coord = WriteRetrospectTutorialModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case let .close:
                break
            }
        }
    }
//
//    private func pushWritingPostScene(vm: HomeViewModel, animated: Bool) {
//        let comp = component.writingPostComponent
//        let coord = WritingMainPostCoordinator(component: comp, navController: navigationController)
//
//        coordinate(coordinator: coord, animated: animated) { coordResult in
//            switch coordResult {
//            case let .backward(needUpdate):
//                vm.routeInputs.needUpdate.onNext(needUpdate)
//            }
//        }
//    }
//
//    private func pushHomeFilterScene(vm: HomeViewModel, filter: PostFilter, animated: Bool) {
//        let comp = component.postFilterComponent(filter: filter)
//        let coord = HomeFilterCoordinator(component: comp, navController: navigationController)
//
//        coordinate(
//            coordinator: coord, animated: animated
//        ) { coordResult in
//            switch coordResult {
//            case let .backward(filter):
//                vm.routeInputs.filterChanged.onNext(filter)
//            }
//        }
//    }
//
//    private func showPostListOrderModal(vm: HomeViewModel, animated: Bool) {
//        let comp = component.postListOrderModal()
//        let coord = PostOrderModalCoordinator(component: comp, navController: navigationController)
//
//        coordinate(coordinator: coord, animated: animated) { coordResult in
//            switch coordResult {
//            case let .ok(order: order):
//                vm.routeInputs.postListOrderChanged.onNext(order)
//            case .cancel: break
//            }
//        }
//    }
//
//    private func showRunningTagModal(vm: HomeViewModel, animated: Bool) {
//        let comp = component.runningTagModal()
//        let coord = RunningTagModalCoordinator(component: comp, navController: navigationController)
//
//        coordinate(coordinator: coord, animated: animated) { coordResult in
//            switch coordResult {
//            case let .ok(tag: tag):
//                vm.routeInputs.runningTagChanged.onNext(tag)
//            case .cancel: break
//            }
//        }
//    }
//
//    private func pushAlarmListScene(vm: HomeViewModel, animated: Bool) {
//        let comp = component.alarmListComponent
//        let coord = AlarmListCoordinator(component: comp, navController: navigationController)
//
//        coordinate(coordinator: coord, animated: animated) { coordResult in
//            switch coordResult {
//            case .backward:
//                vm.routeInputs.alarmChecked.onNext(())
//            }
//        }
//    }
}
