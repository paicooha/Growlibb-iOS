//
//  EditRetrospectComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import UIKit

final class EditRetrospectComponent {
    var scene: (VC: UIViewController, VM: EditRetrospectViewModel) {
        let viewModel = self.viewModel
        return (EditRetrospectViewController(viewModel: viewModel, retrospectionId: retrospectionId), viewModel)
    }

    var viewModel: EditRetrospectViewModel {
        return EditRetrospectViewModel(retrospectionId: retrospectionId)
    }

    var retrospectionId: Int
    
    init(retrospectionId: Int) {
        self.retrospectionId = retrospectionId
    }

}
