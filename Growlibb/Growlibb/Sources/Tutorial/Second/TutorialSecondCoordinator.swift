//
//  TutorialSecondCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/10.
//

import Foundation
import RxSwift

enum TutorialSecondResult {
    case backward
}

final class TutorialSecondCoordinator: BasicCoordinator<TutorialSecondResult> {
    // MARK: Lifecycle
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var appComponent: AppComponent?

    init(component: TutorialSecondComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: TutorialSecondComponent

    override func start(animated: Bool = true) {
        let scene = component.scene
        
        navigationController.pushViewController(scene.VC, animated: animated)
        
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
            .map { TutorialSecondResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)


        scene.VM.routes.next
            .subscribe(onNext: { [weak self] in
                UserDefaults.standard.set(true, forKey: "isPassedTutorial") //튜토리얼을 봤으면 다시 안보여주기 위함
                self?.pushLoginScene()
            })
            .disposed(by: sceneDisposeBag)
    }

    private func pushLoginScene() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window = window
        let navController = UINavigationController()
        window.rootViewController = navController
        AppContext.shared.rootNavigationController = navController
        
        window.makeKeyAndVisible()
        
        let comp = component.loginComponent()
        let coord = LoginCoordinator(component:comp, navController: navigationController)

        coordinate(coordinator: coord)
    }
}
