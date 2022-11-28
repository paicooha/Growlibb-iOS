//
//  SignUpComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/13.
//

import UIKit

class SignUpFirstComponent {
    var scene: (VC: UIViewController, VM: SignUpFirstViewModel) {
        let viewModel = self.viewModel
        return (SignUpFirstViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: SignUpFirstViewModel {
        return SignUpFirstViewModel()
    }
    
    func signUpSecondComponent() -> SignUpSecondComponent {
        return SignUpSecondComponent()
    }
}
