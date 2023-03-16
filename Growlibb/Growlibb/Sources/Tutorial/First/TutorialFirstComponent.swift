//
//  TutorialComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import UIKit

final class TutorialFirstComponent {
    // Component : ViewController, ViewModel을 가지고 있고 한 화면에서 생성 가능한 자식 화면들을 관리하여 계층적으로 화면 관리
    lazy var scene: (VC: TutorialFirstViewController, VM: TutorialFirstViewModel) = (VC: TutorialFirstViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel = TutorialFirstViewModel()

    func tutorialSecondComponent() -> TutorialSecondComponent {
        return TutorialSecondComponent()
    }
}
