//
//  HomeCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation
import RxSwift
import UIKit

enum HomeResult {
    case needCover
}

final class HomeCoordinator: BasicCoordinator<HomeResult> {
    // MARK: Lifecycle

    init(component: HomeComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: HomeComponent

    override func start(animated _: Bool = true) { // VM의 route 바인딩
        let scene = component.scene
        
        scene.VM.routes.writeretrospect
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushWriteRetrospectScene(vm: vm)
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

//    private func pushDetailPostScene(vm: HomeViewModel, postId: Int, animated: Bool) {
//        let comp = component.postDetailComponent(postId: postId)
//        let coord = PostDetailCoordinator(component: comp, navController: navigationController)
//
//        coordinate(coordinator: coord, animated: animated) { coordResult in
//            switch coordResult {
//            case let .backward(_, needUpdate):
//                vm.routeInputs.needUpdate.onNext(needUpdate)
//                vm.routeInputs.detailClosed.onNext(())
//            }
//        }
//    }
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
    private func pushWriteRetrospectScene(vm: HomeViewModel) {
        let comp = component.writeRetrospectComponent()
        let coord = WriteRetrospectCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .backward:
                break
//                vm.routeInputs.needUpdate.onNext(true)
            case .showModal:
                break
            }
        }
    }
}
