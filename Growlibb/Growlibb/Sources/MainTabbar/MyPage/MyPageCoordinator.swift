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
    case needCover
}

final class MyPageCoordinator: BasicCoordinator<MyPageResult> {
    // MARK: Lifecycle

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
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.goEditPassword(animated: true)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.editPhoneNumber
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.goEditPhoneNumber(animated: true)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.editNoti
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.goEditNoti(animated: true)
            })
            .disposed(by: sceneDisposeBag)
        
//        scene.VM.routes.nonMemberCover
//            .map { .needCover }
//            .subscribe(closeSignal)
//            .disposed(by: sceneDisposeBag)
//
//        scene.VM.routes.postListOrder
//            .map { scene.VM }
//            .subscribe(onNext: { [weak self] vm in
//                self?.showPostListOrderModal(vm: vm, animated: false)
//            })
//            .disposed(by: sceneDisposeBag)
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
        let coord = EditPasswordCoordinator(component: comp, navController: navigationController)

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
//
//    private func pushAlarmListScene(vm: HomeViewModel, animated: Bool) {
//        let comp = component.alarmListComponent
//        let coord = AlarmListCoordinator(component: comp, navController: navigationController)
//
//        coordinate(coordinator: coord, animated: animated) { coordResult in
//            switch coordResult {
//            case .backward:
//                vm.routeInputs.alarmChecked.onNext(())
//            }
//        }
//    }
}
