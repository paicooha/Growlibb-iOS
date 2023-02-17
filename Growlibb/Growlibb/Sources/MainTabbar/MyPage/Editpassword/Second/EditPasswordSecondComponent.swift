//
//  EditPasswordComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/13.
//

import UIKit

final class EditPasswordSecondComponent {
    lazy var scene: (VC: EditPasswordSecondViewController, VM: EditPasswordSecondViewModel) = (VC: EditPasswordSecondViewController(viewModel: viewModel), VM: viewModel)
    
    lazy var viewModel = EditPasswordSecondViewModel()

//
    var mainTabComponent: MainTabComponent {
        return MainTabComponent()
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
