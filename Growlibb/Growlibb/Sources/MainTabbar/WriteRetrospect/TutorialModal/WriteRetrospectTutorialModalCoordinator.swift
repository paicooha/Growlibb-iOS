//
//  WriteRetrospectTutorialModalCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/25.
//

import Foundation
import RxSwift

enum WriteRetrospectTutorialModalResult {
    case close
}

final class WriteRetrospectTutorialModalCoordinator: BasicCoordinator<WriteRetrospectTutorialModalResult> {
    var component: WriteRetrospectTutorialModalComponent

    init(component: WriteRetrospectTutorialModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navigationController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.close
            .map { WriteRetrospectTutorialModalResult.close }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    
    }
}
