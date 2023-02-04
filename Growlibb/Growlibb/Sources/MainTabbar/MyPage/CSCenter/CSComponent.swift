//
//  CSComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation

final class CSComponent {
    lazy var scene: (VC: CSViewController, VM: CSViewModel) = (VC: CSViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: CSViewModel = .init()

    func writeRetrospectTutorialModalComponent() -> CSComponent {
        return CSComponent()
    }

//    var modalComponent: ModalComponent {
//        return ModalComponent(whereFrom: "writeretrospect")
//    }
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
