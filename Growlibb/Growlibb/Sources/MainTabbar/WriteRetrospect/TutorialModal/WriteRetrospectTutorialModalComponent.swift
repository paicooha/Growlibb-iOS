//
//  WriteRetrospectTutorialModalComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/25.
//

import UIKit

final class WriteRetrospectTutorialModalComponent {
    lazy var scene: (VC: WriteRetrospectTutorialModalViewController, VM: WriteRetrospectTutorialViewModel) = (VC: WriteRetrospectTutorialModalViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: WriteRetrospectTutorialViewModel = .init()
}
