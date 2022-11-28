//
//  LoginCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import Foundation
import RxSwift

protocol LoginResult {}

final class LoginCoordinator: BasicCoordinator<LoginResult> {
    // MARK: Lifecycle

    init(component: LoginComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: LoginComponent

    override func start(animated _: Bool = true) {
        let scene = component.scene

        navigationController.pushViewController(scene.VC, animated: true)

        scene.VM.routes.loginSuccess
            .subscribe(onNext: { [weak self] _ in
                self?.goMainTabScene(vm: scene.VM, animated: true)
            })
            .disposed(by: sceneDisposeBag)
        
        
        scene.VM.routes.goToSignup
            .subscribe(onNext: { [weak self] in
                self?.pushSignUpScene(animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func goMainTabScene(vm: LoginViewModel, animated: Bool) {
        let comp = component.mainComponent()
        let coord = MainTabbarCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated)
    }
    
    private func pushSignUpScene(animated: Bool) {
        
        let comp = component.signupFirstComponent()
        let coord = SignUpFirstCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .backward:
                break
            case .next:
                break
            }
        }
    }
}
