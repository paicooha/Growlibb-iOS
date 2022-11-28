//
//  SignUpCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/13.
//

import Foundation
import RxSwift

enum SignUpFirstResult {
    case backward
    case next
}

final class SignUpFirstCoordinator: BasicCoordinator<SignUpFirstResult> {
    // MARK: Lifecycle

    init(component: SignUpFirstComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: SignUpFirstComponent

    override func start(animated _: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                Log.d(tag: .lifeCycle, "VC poped")

                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                case .next:
                    break
                }
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.backward
            .map { SignUpFirstResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.next
            .subscribe(onNext: { [weak self] in
                self?.pushSignUpSecond()
            })
            .disposed(by: sceneDisposeBag)
    }

    private func pushSignUpSecond() {
        let comp = component.signUpSecondComponent()
        let coord = SignUpSecondCoordinator(component: comp, navController: navigationController)

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
