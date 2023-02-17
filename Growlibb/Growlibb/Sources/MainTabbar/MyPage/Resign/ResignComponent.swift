//
//  ResignComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
//

import UIKit

final class ResignComponent {
    lazy var scene: (VC: ResignViewController, VM: ResignViewModel) = (VC: ResignViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: ResignViewModel = .init()

    var modalComponent: ModalComponent {
        return ModalComponent(whereFrom: "resign")
    }
    
    var loginComponent: LoginComponent {
        return LoginComponent()
    }
//
//    func postFilterComponent(filter: PostFilter) -> HomeFilterComponent {
//        return HomeFilterComponent(filter: filter)
//    }
//
//    func postListOrderModal() -> PostOrderModalComponent {
//        return PostOrderModalComponent()
//    }
//
//    func runningTagModal() -> RunningTagModalComponent {
//        return RunningTagModalComponent()
//    }
//
//    var alarmListComponent: AlarmListComponent {
//        return AlarmListComponent()
//    }
}
