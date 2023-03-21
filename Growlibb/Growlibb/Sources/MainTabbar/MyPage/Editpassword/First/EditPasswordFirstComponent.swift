//
//  EditPasswordFirstComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/15.
//

import UIKit

final class EditPasswordFirstComponent {
    lazy var scene: (VC: EditPasswordFirstViewController, VM: EditPasswordFirstViewModel) = (VC: EditPasswordFirstViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel = EditPasswordFirstViewModel()

    var editPasswordSecondComponent: EditPasswordSecondComponent {
        return EditPasswordSecondComponent()
    }
    
}
