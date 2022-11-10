//
//  AppCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import RxSwift
import UIKit

final class AppCoordinator: BasicCoordinator<Void> {
    var window: UIWindow

    // MARK: Lifecycle

    init(component: AppComponent, window: UIWindow) {
        self.component = component
        self.window = window
        let navController = UINavigationController()
        window.rootViewController = navController
        AppContext.shared.rootNavigationController = navController
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: AppComponent

    override func start(animated _: Bool = true) {
        BasicLoginKeyChainService.shared.clearIfFirstLaunched()
        window.makeKeyAndVisible()

//        component.loginService.checkLogin()
//            .subscribe(onNext: { result in
//                switch result {
//                case .member:
//                    self.showMain(animated: false)
//                case .memberWaitCertification:
//                    self.showMain(animated: false)
//                case .nonMember:
//                    self.showLogin(animated: false)
////                case .stopped:
////                    self.showLoggedOut(animated: false)
//                }
//            })
//            .disposed(by: sceneDisposeBag)
        self.showTutorial(animated: false)
    }

//    func showMain(animated: Bool) {
//        let comp = component.mainTabComponent
//        let coord = MainTabbarCoordinator(component: comp, navController: navigationController)
//
//        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
//            switch coordResult {
//            case .logout:
//                self?.showLoggedOut(animated: false)
//            }
//        }
//    }

//    func showLogin(animated: Bool) {
//        let comp = component.loginComponent
//        let coord = LoggedOutCoordinator(component: comp, navController: navigationController)
//
//        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
//            switch coordResult {
//            case .loginSuccess:
//                self?.showMain(animated: false)
//            }
//        }
//    }
    func showTutorial(animated: Bool) {
        let comp = component.tutorialFirstComponent
        let coord = TutoriaFirstCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated)
    }
}
