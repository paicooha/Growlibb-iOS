//
//  ModalComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/01.
//

import UIKit

final class ModalComponent {
    var scene: (VC: UIViewController, VM: ModalViewModel) {
        let viewModel = self.viewModel
        let whereFrom = self.whereFrom
        return (ModalViewController(viewModel: viewModel, whereFrom: whereFrom), viewModel)
    }

    var viewModel: ModalViewModel {
        return ModalViewModel(whereFrom: whereFrom)
    }

    init(whereFrom: String) {
        self.whereFrom = whereFrom
    }

    var whereFrom: String

//    func postDetailComponent(postId: Int) -> PostDetailComponent {
//        return PostDetailComponent(postId: postId)
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
