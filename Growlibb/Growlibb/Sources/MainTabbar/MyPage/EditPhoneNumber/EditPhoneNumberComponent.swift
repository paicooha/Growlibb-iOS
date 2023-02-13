//
//  EditPhoneNumberComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
//

import UIKit

final class EditPhoneNumberComponent {
    lazy var scene: (VC: EditPhoneNumberViewController, VM: EditPhoneNumberViewModel) = (VC: EditPhoneNumberViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: EditPhoneNumberViewModel = .init()

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
