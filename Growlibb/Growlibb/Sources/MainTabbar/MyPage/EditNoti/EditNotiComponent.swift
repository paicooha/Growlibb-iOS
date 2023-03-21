//
//  EditNotiComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
//

import UIKit

final class EditNotiComponent {
    lazy var scene: (VC: EditNotiViewController, VM: EditNotiViewModel) = (VC: EditNotiViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: EditNotiViewModel = .init()


}
