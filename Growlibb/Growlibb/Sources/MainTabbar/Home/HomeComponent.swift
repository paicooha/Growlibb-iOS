//
//  HomeComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import UIKit

final class HomeComponent {
    lazy var scene: (VC: HomeViewController, VM: HomeViewModel) = (VC: HomeViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: HomeViewModel = .init()

    var writeRetrospectComponent: WriteRetrospectComponent {
        return WriteRetrospectComponent()
    }
    
    func detailRetrospectComponent(retrospectionId: Int) -> DetailRetrospectComponent {
        return DetailRetrospectComponent(retrospectionId: retrospectionId)
    }
}
