//
//  RetrospectComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import UIKit

final class RetrospectComponent {
    lazy var scene: (VC: RetrospectViewController, VM: RetrospectViewModel) = (VC: RetrospectViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: RetrospectViewModel = .init()

    func writeRetrospectComponent() -> WriteRetrospectComponent {
        return WriteRetrospectComponent()
    }

    func editRetrospectComponent(retrospectionId: Int) -> EditRetrospectComponent {
        return EditRetrospectComponent(retrospectionId: retrospectionId)
    }
    
    var modalComponent: ModalComponent {
        return ModalComponent(whereFrom: .event)
    }
}
