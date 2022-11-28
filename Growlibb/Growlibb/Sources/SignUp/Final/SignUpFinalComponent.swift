//
//  SignUpFinalComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/21.
//

import UIKit

class SignUpFinalComponent {
    var scene: (VC: UIViewController, VM: SignUpFinalViewModel) {
        let viewModel = self.viewModel
        return (SignUpFinalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: SignUpFinalViewModel {
        return SignUpFinalViewModel()
    }
    
    var mainComponent: MainTabComponent {
        return MainTabComponent()
    }
}
