//
//  WriteRetrospectComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/15.
//

import UIKit

final class WriteRetrospectComponent {
    lazy var scene: (VC: WriteRetrospectViewController, VM: WriteRetrospectViewModel) = (VC: WriteRetrospectViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: WriteRetrospectViewModel = .init()

    func writeRetrospectTutorialModalComponent() -> WriteRetrospectTutorialModalComponent {
        return WriteRetrospectTutorialModalComponent()
    }

    var modalComponent: ModalComponent {
        return ModalComponent(whereFrom: "writeretrospect")
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
