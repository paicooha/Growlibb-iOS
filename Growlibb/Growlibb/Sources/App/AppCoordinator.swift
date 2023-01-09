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
        navController.view.backgroundColor = .white
        
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
            if loginKeyChainService.token?.jwt != nil { //jwt가 nil이 아닐 경우 -> jwt 검증
                loginDataManager.checkJwt(viewController: self)
            }
            else{ //jwt가 nil -> 로그인 화면 이동
                self.showLogin(animated: true)
            }
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
        self.loginKeyChainService.setLoginInfo(loginType: LoginType.member, userID: result.userID, token: LoginToken(jwt: result.jwt)) //jwt 검증 성공시, 서버에서 새로 발급하는 jwt keychain에 저장
        self.userKeyChainService.nickName = result.nickname
        
        if result.notificationStatus == "Y" { //알림이 '예'일 경우에 fcm 토큰 갱신 호출
            self.loginDataManager.patchFcmToken(viewController: self, fcmToken: Messaging.messaging().fcmToken ?? "")
        }
        else{
            self.showMain(animated: true) //메인으로 이동
        }
    }
    
    func didFailgetJwt(){
        AppContext.shared.makeToast("로그인에 문제가 발생했습니다. 다시 로그인해주세요")
        self.userKeyChainService.clear()
        self.loginKeyChainService.clear()
        self.showLogin(animated: true)
    }
    
    func didSuccessPatchFcmToken(code: Int){
        if code == 1000 { //성공
            self.userKeyChainService.fcmToken = Messaging.messaging().fcmToken!
            self.showMain(animated: true) //메인으로 이동
        }
        else if code == 2021 { //토큰 갱신 실패
            AppContext.shared.makeToast("로그인에 문제가 발생했습니다. 다시 로그인해주세요")
            
            self.userKeyChainService.clear()
            self.loginKeyChainService.clear()
            self.showLogin(animated: true)
        }
    }

    func failedToRequest(message: String) {
        self.showLogin(animated: true)
        AppContext.shared.makeToast(message)
    }
}
