//
//  SignUpFinalCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/21.
//

import Foundation
import RxSwift

enum SignUpFinalResult {
    case next
}

final class SignUpFinalCoordinator: BasicCoordinator<SignUpFinalResult> {
    // MARK: Lifecycle
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var appComponent: AppComponent?

    init(component: SignUpFinalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: SignUpFinalComponent

    override func start(animated _: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)
        
        scene.VM.routes.next
            .subscribe(onNext: { [weak self] in
                self?.pushHomeScene()
            })
            .disposed(by: sceneDisposeBag)
    
    }

    private func pushHomeScene() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window = window
        let navController = UINavigationController()
        window.rootViewController = navController
        AppContext.shared.rootNavigationController = navController
        
        window.makeKeyAndVisible()
        
        let comp = component.mainComponent
        let coord = MainTabbarCoordinator(component:comp, navController: navigationController)

        coordinate(coordinator: coord)
    }
}
