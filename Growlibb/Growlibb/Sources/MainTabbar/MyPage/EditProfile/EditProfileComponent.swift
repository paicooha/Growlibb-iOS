//
//  EditProfileComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/12.
//

import UIKit

final class EditProfileComponent {
    lazy var scene: (VC: EditProfileViewController, VM: EditProfileViewModel) = (VC: EditProfileViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: EditProfileViewModel = .init()

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
