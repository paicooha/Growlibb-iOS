//
//  RetrospectCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation
import RxSwift
import UIKit

enum RetrospectResult {
    case goWriteRetrospect
}

final class RetrospectCoordinator: BasicCoordinator<RetrospectResult> {
    // MARK: Lifecycle

    init(component: RetrospectComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: RetrospectComponent

    override func start(animated _: Bool = true) { // VM의 route 바인딩
        let scene = component.scene

        scene.VM.routes.writeretrospect
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushWriteRetrospectScene(vm: vm)
            })
            .disposed(by: sceneDisposeBag)
//
//        scene.VM.routes.alarmList
//            .map { scene.VM }
//            .subscribe(onNext: { [weak self] vm in
//                self?.pushAlarmListScene(vm: vm, animated: true)
//            })
//            .disposed(by: sceneDisposeBag)
    }

    private func pushWriteRetrospectScene(vm: RetrospectViewModel) {
        let comp = component.writeRetrospectComponent()
        let coord = WriteRetrospectCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(true)
            case .showModal:
                break
            }
        }
    }
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
}
