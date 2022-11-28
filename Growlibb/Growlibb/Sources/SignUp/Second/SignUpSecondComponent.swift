//
//  SignUpSecondComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/16.
//

import UIKit

class SignUpSecondComponent {
    var scene: (VC: UIViewController, VM: SignUpSecondViewModel) {
        let viewModel = self.viewModel
        return (SignUpSecondViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: SignUpSecondViewModel {
        return SignUpSecondViewModel()
    }
    
    func signUpFinalComponent() -> SignUpFinalComponent {
        return SignUpFinalComponent()
    }
}
