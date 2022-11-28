//
//  AppCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import RxSwift
import UIKit
import FirebaseMessaging

final class AppCoordinator: BasicCoordinator<Void> {
    var window: UIWindow
    lazy var loginDataManager = LoginDataManager()
    private var loginKeyChainService: LoginKeyChainService
    private var userKeyChainService: UserKeychainService

    // MARK: Lifecycle

    init(component: AppComponent, window: UIWindow, loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
         userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared) {
        self.component = component
        self.window = window
        let navController = UINavigationController()
        window.rootViewController = navController
        AppContext.shared.rootNavigationController = navController
        self.loginKeyChainService = BasicLoginKeyChainService.shared
        self.userKeyChainService = BasicUserKeyChainService.shared
        
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: AppComponent

    override func start(animated _: Bool = true) {
        BasicLoginKeyChainService.shared.clearIfFirstLaunched()
        window.makeKeyAndVisible()
        
        if UserDefaults.standard.bool(forKey: "isPassedTutorial"){
            loginDataManager.checkJwt(viewController: self)
            print(Constants().HEADERS.value(for: "x-access-token"))
        }
        else{
            self.showTutorial(animated: true)
        }
    }

    func showMain(animated: Bool) {
        let comp = component.mainTabComponent
        let coord = MainTabbarCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
            switch coordResult {
            case .logout:
                break
            }
        }
    }

    func showLogin(animated: Bool) {
        let comp = component.loginComponent
        let coord = LoginCoordinator(component:comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated)
    }
    
    func showTutorial(animated: Bool) {
        let comp = component.tutorialFirstComponent
        let coord = TutoriaFirstCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated)
    }
}

extension AppCoordinator {
    func didSuccessGetJwt(result: GetJwtResult) {
        self.loginKeyChainService.setLoginInfo(loginType: LoginType.member, userID: result.userId, token: LoginToken(jwt: result.jwt))
        self.showLogin(animated: true)
    }
    
    func didFailgetJwt(){
        AppContext.shared.makeToast("로그인에 문제가 발생했습니다. 다시 로그인해주세요")
        self.loginKeyChainService.clear()
        self.showLogin(animated: true)
    }

    func failedToRequest(message: String) {
        self.showLogin(animated: true)
        AppContext.shared.makeToast(message)
    }
}
