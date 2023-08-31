//
//  RetrospectCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation
import RxSwift
import UIKit

enum RetrospectResult {
    case goWriteRetrospect
}

final class RetrospectCoordinator: BasicCoordinator<RetrospectResult> {
    // MARK: Lifecycle

    init(component: RetrospectComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: RetrospectComponent

    override func start(animated _: Bool = true) { // VM의 route 바인딩
        let scene = component.scene

        scene.VM.routes.writeretrospect
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushWriteRetrospectScene(vm: vm)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.editRetrospect
            .subscribe(onNext: { id in
                self.goEditRetrospect(retrospectionId: id)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.eventShowModal
            .map { (vm: scene.VM, eventInfo: $0 ) }
            .subscribe(onNext: { [ weak self] info in
                self?.showEventModal(vm: info.vm, eventInfo: info.eventInfo)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func pushWriteRetrospectScene(vm: RetrospectViewModel) {
        let comp = component.writeRetrospectComponent()
        let coord = WriteRetrospectCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .backward:
                break
            case let .showEventModal(eventDay, eventScore):
                vm.routes.eventShowModal.onNext((eventDay, eventScore))
            case .completed:
                vm.routeInputs.needUpdate.onNext(true) //회고 수정하기로 바꿔야함 (작성완료 시)
            }
        }
    }

    private func goEditRetrospect(retrospectionId: Int) {
        
        let comp = component.editRetrospectComponent(retrospectionId: retrospectionId)
        let coord = EditRetrospectCoordinator(component:comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .backward:
                break
            case .edited:
                break
            }
        }
    }
    
    private func showEventModal(vm: RetrospectViewModel, eventInfo: (Int, Int)) {
        let comp = component.modalComponent
        let coord = ModalCoordinator(component: comp, navController: navigationController)
        comp.eventDescription = "\(L10n.Retrospect.Modal.Event.title)\(eventInfo.0)\(L10n.Retrospect.Modal.Event.first)\(eventInfo.1)\(L10n.Retrospect.Modal.Event.second)"

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .redirect:
                break
            case .close:
                break
            }
        }
    }
}
