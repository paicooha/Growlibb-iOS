//
//  ViewRetrospectComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import UIKit

final class RetrospectListComponent {
    lazy var scene: (VC: RetrospectListViewController, VM: RetrospectListViewModel) = (VC: RetrospectListViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: RetrospectListViewModel = .init()

    func retrospectDetailComponent(retrospectionId: Int) -> DetailRetrospectComponent {
        return DetailRetrospectComponent(retrospectionId: retrospectionId)
    }
}
