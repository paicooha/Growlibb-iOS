//
//  EditNotiComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
//

import UIKit

final class EditNotiComponent {
    lazy var scene: (VC: EditNotiViewController, VM: EditNotiViewModel) = (VC: EditNotiViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: EditNotiViewModel = .init()

//    var csComponent: CSComponent {
//        return CSComponent()
//    }
//
//    var writingPostComponent: WritingMainPostComponent {
//        return WritingMainPostComponent()
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
