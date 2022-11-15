//
//  MainTabComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import Foundation

final class MainTabComponent {
    lazy var scene: (VC: MainTabViewController, VM: MainTabViewModel) = (
        VC: MainTabViewController(viewModel: viewModel),
        VM: viewModel
    )

    lazy var viewModel = MainTabViewModel()

    var homeComponent: HomeComponent {
        return HomeComponent()
    }

    var myPageComponent: MyPageComponent {
        return MyPageComponent()
    }

    var retrospectComponent: RetrospectComponent {
        return RetrospectComponent()
    }
}
