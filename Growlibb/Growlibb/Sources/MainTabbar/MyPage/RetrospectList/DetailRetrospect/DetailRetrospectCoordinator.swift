//
//  DetailRetrospectCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import Foundation
import RxSwift
import UIKit

enum DetailRetrospectResult {
    case backward
    case showModal
}

final class DetailRetrospectCoordinator: BasicCoordinator<DetailRetrospectResult> {
    // MARK: Lifecycle

    init(component: DetailRetrospectComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: DetailRetrospectComponent

    override func start(animated _: Bool = true) { // VM의 route 바인딩
        let scene = component.scene
        
        navigationController.pushViewController(scene.VC, animated: true)
        
        closeSignal
            .subscribe(onNext: { [weak self] result in
                Log.d(tag: .lifeCycle, "VC poped")

                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                case .showModal:
                    break
                }
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.backward
            .map { _ in DetailRetrospectResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.modify
            .subscribe(onNext: { [weak self] _ in
//                self?.gomodifyRetrospect()
            })
            .disposed(by: sceneDisposeBag)
    }
}
