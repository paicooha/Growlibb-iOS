//
//  CSCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation
import RxSwift
import UIKit

enum CSResult {
    case backward
}

final class CsCoordinator: BasicCoordinator<CSResult> {
    // MARK: Lifecycle

    init(component: CSComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: CSComponent

    override func start(animated _: Bool = true) { 
        let scene = component.scene
        
        navigationController.pushViewController(scene.VC, animated: true)
        
        closeSignal
            .subscribe(onNext: { [weak self] result in
                Log.d(tag: .lifeCycle, "VC poped")
                
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.backward
            .map { CSResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}

