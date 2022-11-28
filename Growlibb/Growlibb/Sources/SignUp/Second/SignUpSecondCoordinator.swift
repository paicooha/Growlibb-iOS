//
//  SignUpSecondCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/21.
//

import Foundation
import RxSwift

enum SignUpSecondResult {
    case backward
    case next
}

final class SignUpSecondCoordinator: BasicCoordinator<SignUpSecondResult> {
    // MARK: Lifecycle

    init(component: SignUpSecondComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: SignUpSecondComponent

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
            .map { SignUpSecondResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.next
            .subscribe(onNext: { [weak self] in
                self?.pushSignUpFinal()
            })
            .disposed(by: sceneDisposeBag)
    }

    private func pushSignUpFinal() {
        let comp = component.signUpFinalComponent()
        let coord = SignUpFinalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .next:
                break
            }
        }
    }
}
