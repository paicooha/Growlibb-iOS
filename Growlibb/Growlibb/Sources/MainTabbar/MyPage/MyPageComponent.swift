//
//  MyComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import UIKit

final class MyPageComponent {
    lazy var scene: (VC: MyPageViewController, VM: MyPageViewModel) = (VC: MyPageViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: MyPageViewModel = .init()

    var csComponent: CSComponent {
        return CSComponent()
    }

    var editProfileComponent: EditProfileComponent {
        return EditProfileComponent()
    }
    
    var editPasswordComponent: EditPasswordFirstComponent {
        return EditPasswordFirstComponent()
    }

    var editPhoneNumberComponent: EditPhoneNumberComponent {
        return EditPhoneNumberComponent()
    }
    
    var editNotiComponent: EditNotiComponent {
        return EditNotiComponent()
    }
    
    var resignComponent: ResignComponent {
        return ResignComponent()
    }
    
    var modalComponent: ModalComponent {
        return ModalComponent(whereFrom: .logout)
    }
    
    var loginComponent: LoginComponent {
        return LoginComponent()
    }
    
    var retrospectListComponent: RetrospectListComponent {
        return RetrospectListComponent()
    }
}
