//
//  DetailRetrospectCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import Foundation
import RxSwift
import UIKit

enum DetailRetrospectResult {
    case backward
    case showModal
}

final class DetailRetrospectCoordinator: BasicCoordinator<DetailRetrospectResult> {
    // MARK: Lifecycle

    init(component: DetailRetrospectComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: DetailRetrospectComponent

    override func start(animated _: Bool = true) { // VM의 route 바인딩
        let scene = component.scene
        
        navigationController.pushViewController(scene.VC, animated: true)
        
        closeSignal
            .subscribe(onNext: { [weak self] result in
                Log.d(tag: .lifeCycle, "VC poped")

                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                case .showModal:
                    break
                }
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.backward
            .map { _ in DetailRetrospectResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.modify
            .subscribe(onNext: { id in
                self.goEditRetrospect(vm: scene.VM, retrospectionId: id)
            })
            .disposed(by: sceneDisposeBag)
    }
    
    private func goEditRetrospect(vm: DetailRetrospectViewModel, retrospectionId: Int) {
        
        let comp = component.editRetrospectComponent(retrospectionId: retrospectionId)
        let coord = EditRetrospectCoordinator(component:comp, navController: navigationController)
        
        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
                
            case .backward:
                break
            case .edited:
                vm.routeInputs.needUpdate.onNext(true)
            }
        }
    }
}
