//
//  FindEmailorPasswordViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/29.
//

import UIKit

class FindEmailorPasswordComponent {
    var scene: (VC: UIViewController, VM: FindEmailorPasswordViewModel) {
        let viewModel = self.viewModel
        return (FindEmailorPasswordViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: FindEmailorPasswordViewModel {
        return FindEmailorPasswordViewModel()
    }
    
    func loginComponent() -> LoginComponent {
        return LoginComponent()
    }
}
