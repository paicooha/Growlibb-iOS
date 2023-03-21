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

}
