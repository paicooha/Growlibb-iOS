//
//  ModalComponent.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/01.
//

import UIKit

final class ModalComponent {
    var scene: (VC: UIViewController, VM: ModalViewModel) {
        let viewModel = self.viewModel
        let whereFrom = self.whereFrom
        return (ModalViewController(viewModel: viewModel, whereFrom: whereFrom, eventDescription: eventDescription), viewModel)
    }

    var viewModel: ModalViewModel {
        return ModalViewModel()
    }

    init(whereFrom: ModalKind, eventDescription: String? = nil) {
        self.whereFrom = whereFrom
        self.eventDescription = eventDescription
    }

    var whereFrom: ModalKind
    var eventDescription: String? = nil
}
