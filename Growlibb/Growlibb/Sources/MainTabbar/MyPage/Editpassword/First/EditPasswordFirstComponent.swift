//
//  EditPasswordFirstComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/15.
//

import UIKit

final class EditPasswordFirstComponent {
    lazy var scene: (VC: EditPasswordFirstViewController, VM: EditPasswordFirstViewModel) = (VC: EditPasswordFirstViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: EditPasswordFirstViewModel = .init()

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
