//
//  ResignCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
//

import Foundation
import RxSwift
import UIKit

enum ResignResult {
    case backward
}

final class ResignCoordinator: BasicCoordinator<ResignResult> {
    // MARK: Lifecycle
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var appComponent: AppComponent?
    
    init(component: ResignComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }
    
    // MARK: Internal
    
    var component: ResignComponent
    
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
        
        scene.VM.routes.modal
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.showResignModal(vm: vm)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.backward
            .map { ResignResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.goLogin
            .subscribe(onNext: { _ in
                self.pushLoginScene()
            })
            .disposed(by: sceneDisposeBag)
    }
    
    private func showResignModal(vm: ResignViewModel) {
        let comp = component.modalComponent
        let coord = ModalCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .redirect:
                vm.routes.goLogin.onNext(())
            case .close:
                break
            }
        }
    }
    
    private func pushLoginScene() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window = window
        let navController = UINavigationController()
        window.rootViewController = navController
        AppContext.shared.rootNavigationController = navController
        
        window.makeKeyAndVisible()
        
        let comp = component.loginComponent
        let coord = LoginCoordinator(component:comp, navController: navigationController)

        coordinate(coordinator: coord)
    }
}
