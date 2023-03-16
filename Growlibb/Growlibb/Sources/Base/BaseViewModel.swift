//
//  BaseViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/02.
//

import UIKit
import RxSwift

class BaseViewModel {
    var toast = PublishSubject<String?>()
    var toastActivity = PublishSubject<Bool>()
}
