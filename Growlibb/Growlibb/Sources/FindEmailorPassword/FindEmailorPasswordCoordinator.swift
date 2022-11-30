//
//  FindEmailorPasswordCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/29.
//

import Foundation
import RxSwift

enum FindEmailorPasswordResult {
    case backward
    case login
}

final class FindEmailorPasswordCoordinator: BasicCoordinator<FindEmailorPasswordResult> {
    // MARK: Lifecycle

    init(component: FindEmailorPasswordComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: FindEmailorPasswordComponent

    override func start(animated _: Bool = true) {
        let scene = component.scene

        navigationController.pushViewController(scene.VC, animated: true)
        
        closeSignal
            .subscribe(onNext: { [weak self] result in
                Log.d(tag: .lifeCycle, "VC poped")

                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                case .login:
                    break
                }
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.backward
            .map { FindEmailorPasswordResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.login
            .subscribe(onNext: { [weak self] in
                self?.pushLoginScene()
            })
            .disposed(by: sceneDisposeBag)
        
    }

    private func pushLoginScene() {
        
        let comp = component.loginComponent()
        let coord = LoginCoordinator(component:comp, navController: navigationController)

        coordinate(coordinator: coord)
    }
}
