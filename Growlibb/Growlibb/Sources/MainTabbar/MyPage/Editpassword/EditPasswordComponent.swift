//
//  EditPasswordComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/13.
//

import UIKit

final class EditPasswordComponent {
    lazy var scene: (VC: EditPasswordViewController, VM: EditPasswordViewModel) = (VC: EditPasswordViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: EditPasswordViewModel = .init()

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
