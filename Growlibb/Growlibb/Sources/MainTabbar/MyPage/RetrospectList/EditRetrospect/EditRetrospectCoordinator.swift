//
//  EditRetrospectCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import Foundation
import RxSwift
import UIKit

enum EditRetrospectResult {
    case backward
    case edited
}

final class EditRetrospectCoordinator: BasicCoordinator<EditRetrospectResult> {
    // MARK: Lifecycle

    init(component: EditRetrospectComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: EditRetrospectComponent

    override func start(animated _: Bool = true) { // VM의 route 바인딩
        let scene = component.scene
        
        navigationController.pushViewController(scene.VC, animated: true)
        
        closeSignal
            .subscribe(onNext: { [weak self] result in
                Log.d(tag: .lifeCycle, "VC poped")

                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                case .edited:
                    self?.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.backward
            .map { EditRetrospectResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.edited
            .map { EditRetrospectResult.edited }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
