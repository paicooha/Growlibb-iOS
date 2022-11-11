//
//  TutorialComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import UIKit

final class TutorialFirstComponent {
    lazy var scene: (VC: TutorialFirstViewController, VM: TutorialFirstViewModel) = (VC: TutorialFirstViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel = TutorialFirstViewModel()

    func tutorialSecondComponent() -> TutorialSecondComponent {
        return TutorialSecondComponent()
    }
}
