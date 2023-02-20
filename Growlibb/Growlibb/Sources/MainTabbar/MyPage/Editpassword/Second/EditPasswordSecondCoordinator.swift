//
//  EditPasswordCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/13.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

enum EditPasswordSecondResult {
    case backward
}

final class EditPasswordSecondCoordinator: BasicCoordinator<EditPasswordSecondResult> {
    // MARK: Lifecycle
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var appComponent: AppComponent?
    
    init(component: EditPasswordSecondComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }
    
    // MARK: Internal
    
    var component: EditPasswordSecondComponent
    
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
            .map { EditPasswordSecondResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.goMyPage
            .subscribe({ _ in
                self.goMyPage(animated: true)
            })
            .disposed(by: sceneDisposeBag)

    }
    
    private func goMyPage(animated: Bool) {
        self.navigationController.popToRootViewController(animated: true)

    }
}
