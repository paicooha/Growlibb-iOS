//
//  EditNotiCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
//

import Foundation
import RxSwift
import UIKit

enum EditNotiResult {
    case backward
}

final class EditNotiCoordinator: BasicCoordinator<EditNotiResult> {
    // MARK: Lifecycle
    
    init(component: EditNotiComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }
    
    // MARK: Internal
    
    var component: EditNotiComponent
    
    override func start(animated _: Bool = true) { // VM의 route 바인딩
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
            .map { EditNotiResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
