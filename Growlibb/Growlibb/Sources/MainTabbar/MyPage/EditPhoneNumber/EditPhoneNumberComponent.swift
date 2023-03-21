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


}
