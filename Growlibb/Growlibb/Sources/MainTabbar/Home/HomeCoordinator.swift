//
//  HomeCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation
import RxSwift
import UIKit

enum HomeResult {
    
}

final class HomeCoordinator: BasicCoordinator<HomeResult> {
    // MARK: Lifecycle

    init(component: HomeComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: HomeComponent

    override func start(animated _: Bool = true) { // VM의 route 바인딩
        let scene = component.scene
        
        scene.VM.routes.writeretrospect
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushWriteRetrospectScene(vm: vm)
            })
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.detailRetrospect
            .map { (scene.VM, $0) }
            .subscribe(onNext: { [weak self] (vm, id) in
                self?.pushDetailRetrospectScene(vm: vm, retrospectionId: id)
            })
            .disposed(by: sceneDisposeBag)
    }
        
    private func pushWriteRetrospectScene(vm: HomeViewModel) {
        let comp = component.writeRetrospectComponent
        let coord = WriteRetrospectCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .backward:
                break
            case .showEventModal:
                break
            case .completed:
                vm.routeInputs.needUpdate.onNext(true)
            }
        }
    }
    
    private func pushDetailRetrospectScene(vm: HomeViewModel, retrospectionId: Int) {
        let comp = component.detailRetrospectComponent(retrospectionId: retrospectionId)
        let coord = DetailRetrospectCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .backward:
                break
            case .showModal:
                break
            }
        }
    }
}
