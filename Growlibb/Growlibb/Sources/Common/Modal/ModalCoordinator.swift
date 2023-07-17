//
//  ModalCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/01.
//

import Foundation
import UIKit

enum ModalResult {
    case redirect
    case close
}

final class ModalCoordinator: BasicCoordinator<ModalResult> {
    var component: ModalComponent

    init(component: ModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navigationController.present(scene.VC, animated: false)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.close
            .map { ModalResult.close }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
        
        scene.VM
            .routes.backward
            .map { ModalResult.redirect }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

    }
}
