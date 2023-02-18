//
//  DetailRetrospectComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import UIKit

final class DetailRetrospectComponent {
    var scene: (VC: UIViewController, VM: DetailRetrospectViewModel) {
        let viewModel = self.viewModel
        return (DetailRetrospectViewController(viewModel: viewModel, retrospectionId: retrospectionId), viewModel)
    }

    var viewModel: DetailRetrospectViewModel {
        return DetailRetrospectViewModel(retrospectionId: retrospectionId)
    }

    var retrospectionId: Int
    
    init(retrospectionId: Int) {
        self.retrospectionId = retrospectionId
    }

}
