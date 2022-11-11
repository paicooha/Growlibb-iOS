//
//  TutorialCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import Foundation
import RxSwift

enum TutorialFirstResult {
    case next
}

final class TutoriaFirstCoordinator: BasicCoordinator<TutorialFirstResult> {
    // MARK: Lifecycle

    init(component: TutorialFirstComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: TutorialFirstComponent

    override func start(animated _: Bool = true) {
        let scene = component.scene

        navigationController.pushViewController(scene.VC, animated: false)
        
        scene.VM.routes.next
            .subscribe(onNext: { [weak self] in
                self?.pushTutorialSecond()
            })
            .disposed(by: sceneDisposeBag)

        
    }

    private func pushTutorialSecond() {
        let comp = component.tutorialSecondComponent()
        let coord = TutorialSecondCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .backward:
                break
            }
        }
    }
}
