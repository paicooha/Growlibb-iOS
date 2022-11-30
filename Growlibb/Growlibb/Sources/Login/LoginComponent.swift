//
//  LoginComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import UIKit

class LoginComponent {
    var scene: (VC: UIViewController, VM: LoginViewModel) {
        let viewModel = self.viewModel
        return (LoginViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: LoginViewModel {
        return LoginViewModel()
    }
    
    func signupFirstComponent() -> SignUpFirstComponent {
        return SignUpFirstComponent()
    }
    
    func mainComponent() -> MainTabComponent {
        return MainTabComponent()
    }
    
    func findEmailorPasswordComponent() -> FindEmailorPasswordComponent {
        return FindEmailorPasswordComponent()
    }
}
