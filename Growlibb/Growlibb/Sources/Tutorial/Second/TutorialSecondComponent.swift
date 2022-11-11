//
//  TutorialSecondComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/10.
//

import UIKit

final class TutorialSecondComponent {
    lazy var scene: (VC: TutorialSecondViewController, VM: TutorialSecondViewModel) = (VC: TutorialSecondViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel = TutorialSecondViewModel()

    func loginComponent() -> LoginComponent {
        return LoginComponent()
    }
}
