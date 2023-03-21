//
//  WriteRetrospectCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/15.
//

import Foundation
import RxSwift
import UIKit

enum WriteRetrospectResult {
    case completed
    case backward
    case showEventModal(eventDay: Int, eventScore: Int)
}

final class WriteRetrospectCoordinator: BasicCoordinator<WriteRetrospectResult> {
    // MARK: Lifecycle

    init(component: WriteRetrospectComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: WriteRetrospectComponent

    override func start(animated _: Bool = true) { // VM의 route 바인딩
        let scene = component.scene
        
        navigationController.pushViewController(scene.VC, animated: true)
        
        closeSignal
            .subscribe(onNext: { [weak self] result in
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.backward
            .subscribe(onNext: { isShowModal in
                if !isShowModal { //하나라도 내용이 차있으면
                    self.showTrueDeleteModal(vm: scene.VM)
                }
                else{
                    self.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.showTutorial
            .subscribe(onNext: { [weak self] _ in
                self?.showWriteRetrospectTutorialModal()
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.completed
            .map { WriteRetrospectResult.completed }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.showEventModal
            .map { WriteRetrospectResult.showEventModal(eventDay: $0.0, eventScore: $0.1) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

    }

    private func showWriteRetrospectTutorialModal() {
        let comp = component.writeRetrospectTutorialModalComponent()
        let coord = WriteRetrospectTutorialModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .close:
                break
            }
        }
    }

    private func showTrueDeleteModal(vm: WriteRetrospectViewModel, whereFrom:String="writeretrospect") {
        let comp = component.modalComponent
        let coord = ModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .redirect:
                vm.routes.backward.onNext(true) //닫기
                break
            case .close:
                break
            }
        }
    }
}
