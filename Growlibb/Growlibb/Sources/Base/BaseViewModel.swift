//
//  BaseViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/02.
//

import UIKit
import RxSwift

class BaseViewModel {
    init() {
        #if DEBUG
            print("[init:   ViewModel]  \(Self.self) ")
        #endif
        Log.d(tag: .lifeCycle, "VM Initialized")
    }

    deinit {
        Log.d(tag: .lifeCycle, "VM Deinitailized")
    }

    var toast = PublishSubject<String?>()
    var toastActivity = PublishSubject<Bool>()
}
