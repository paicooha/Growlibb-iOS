//
//  MainTabbarCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import Foundation
import RxSwift
import UIKit

enum MainTabbarResult {
    case logout
}

final class MainTabbarCoordinator: BasicCoordinator<MainTabbarResult> {
    // MARK: Lifecycle

    init(component: MainTabComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: MainTabComponent

    override func start(animated _: Bool = true) {
        startTabbarController()
    }

    // MARK: Private

    private func startTabbarController() {
        let scene = component.scene
        
        UITabBar.appearance().backgroundColor = .white

        scene.VC.viewControllers = [
            configureAndGetHomeScene(vm: scene.VM),
            configureAndGetRetrospectScene(vm: scene.VM),
            configureAndGetMyPageScene(vm: scene.VM),
        ]

        navigationController.pushViewController(scene.VC, animated: false)

        closeSignal.subscribe(onNext: { [weak self] _ in
            self?.navigationController.popViewController(animated: false)
        })
        .disposed(by: sceneDisposeBag)
    }

    private func configureAndGetHomeScene(vm: MainTabViewModel) -> UIViewController {
        let comp = component.homeComponent
        let coord = HomeCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: false)

        vm.routes.home
            .subscribe(onNext: {
//                comp.viewModel.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: sceneDisposeBag)

        return comp.scene.VC
    }

    private func configureAndGetRetrospectScene(vm: MainTabViewModel) -> UIViewController {
        let comp = component.retrospectComponent
        let coord = RetrospectCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: false, needRelease: false)

        vm.routes.retrospect
            .subscribe(onNext: {
//                comp.scene.VM.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: sceneDisposeBag)

        return comp.scene.VC
    }

    private func configureAndGetMyPageScene(vm: MainTabViewModel) -> UIViewController {
        let comp = component.myPageComponent
        let coord = MyPageCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: false, needRelease: false)

        vm.routes.myPage
            .subscribe(onNext: {
//                comp.scene.VM.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: sceneDisposeBag)

        return comp.scene.VC
    }
}
