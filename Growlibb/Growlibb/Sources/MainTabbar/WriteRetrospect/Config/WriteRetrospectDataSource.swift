//
//  WriteRetrospectDataSource.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/02.
//

import Foundation
import RxDataSources

public struct WriteRetrospectSection {
    public var items: [String]
    var header: String?
    public var identity: String
    
    init(items: [String]) {
        self.items = items
        self.header = nil
        self.identity = UUID().uuidString
    }
}

extension WriteRetrospectSection: AnimatableSectionModelType {

    public typealias Identity = String
    
    public init(original: WriteRetrospectSection, items: [String]) {
        self = original
        self.items = items
    }
}
