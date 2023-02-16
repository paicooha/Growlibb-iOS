//
//  MyCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation
import RxSwift
import UIKit

enum MyPageResult {
    case logout
}

final class MyPageCoordinator: BasicCoordinator<MyPageResult> {
    // MARK: Lifecycle
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var appComponent: AppComponent?
    
    init(component: MyPageComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }
    
    // MARK: Internal
    
    var component: MyPageComponent
    
    override func start(animated _: Bool = true) { // VM의 route 바인딩
        let scene = component.scene
        
        scene.VM.routes.goCS
            .subscribe(onNext: { [weak self] _ in
                self?.goCS()
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.editProfile
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.goEditProfile(vm: vm, animated: true)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.editPassword
            .subscribe(onNext: { [weak self] _ in
                self?.goEditPassword(animated: true)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.editPhoneNumber
            .subscribe(onNext: { [weak self] _ in
                self?.goEditPhoneNumber(animated: true)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.editNoti
            .subscribe(onNext: { [weak self] _ in
                self?.goEditNoti(animated: true)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.goResign
            .subscribe(onNext: { [weak self] _ in
                self?.goResign(animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.logout
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.showLogoutModal(vm: vm)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.goLogin
            .subscribe(onNext: { _ in
                self.pushLoginScene()
            })
            .disposed(by: sceneDisposeBag)
        //
        //        scene.VM.routes.runningTag
        //            .map { scene.VM }
        //            .subscribe(onNext: { [weak self] vm in
        //                self?.showRunningTagModal(vm: vm, animated: false)
        //            })
        //            .disposed(by: sceneDisposeBag)
        //
        //        scene.VM.routes.alarmList
        //            .map { scene.VM }
        //            .subscribe(onNext: { [weak self] vm in
        //                self?.pushAlarmListScene(vm: vm, animated: true)
        //            })
        //            .disposed(by: sceneDisposeBag)
    }
    
    private func goCS() {
        let comp = component.csComponent
        let coord = CsCoordinator(component: comp, navController: navigationController)
        
        comp.viewModel.routeInputs.needUpdate.onNext(true)
        
        coordinate(coordinator: coord, animated: true) { coordResult in
            switch coordResult {
            case .backward:
                break
            }
        }
    }
    
    private func goEditProfile(vm: MyPageViewModel, animated: Bool) {
        let comp = component.editProfileComponent
        let coord = EditProfileCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward:
                vm.routeInputs.needUpdate.onNext(true)
            }
        }
    }
    
    private func goEditPassword(animated: Bool) {
        let comp = component.editPasswordComponent
        let coord = EditPasswordFirstCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward:
                break
            }
        }
    }
    //
    private func goEditPhoneNumber(animated: Bool) {
        let comp = component.editPhoneNumberComponent
        let coord = EditPhoneNumberCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward:
                break
            }
        }
    }
    //
    private func goEditNoti(animated: Bool) {
        let comp = component.editNotiComponent
        let coord = EditNotiCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward:
                break
            }
        }
    }
    
    private func goResign(animated: Bool) {
        let comp = component.resignComponent
        let coord = ResignCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward:
                break
            }
        }
    }
    
    private func showLogoutModal(vm: MyPageViewModel, whereFrom:String="logout") {
        let comp = component.modalComponent
        let coord = ModalCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .redirect:
                vm.routeInputs.goLogin.onNext(true)
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
