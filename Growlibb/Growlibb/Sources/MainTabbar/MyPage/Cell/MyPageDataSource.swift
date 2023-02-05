//
//  MyPageDataSource.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation
import RxDataSources

public struct MyPageSection {
    public var items: [String]
    public var identity: String
    
    init(items: [String]) {
        self.items = items
        self.identity = UUID().uuidString
    }
}

extension MyPageSection: SectionModelType {
    public typealias Identity = String
    
    public init(original: MyPageSection, items: [String]) {
        self = original
        self.items = items
    }
}
