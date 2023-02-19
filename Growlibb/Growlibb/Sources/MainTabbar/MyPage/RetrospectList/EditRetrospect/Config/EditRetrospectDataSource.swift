//
//  EditRetrospectDataSource.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/19.
//

import Foundation
import RxDataSources

struct EditRetrospectSection {
    public var items: [EditRetrospectConfig]
    var identity: String

    init(items: [EditRetrospectConfig]) {
        self.items = items
        self.identity = UUID().uuidString
    }
}

extension EditRetrospectSection: AnimatableSectionModelType{
    typealias Item = EditRetrospectConfig
    
    init(original: EditRetrospectSection, items: [EditRetrospectConfig]) {
        self = original
        self.items = items
    }
}
