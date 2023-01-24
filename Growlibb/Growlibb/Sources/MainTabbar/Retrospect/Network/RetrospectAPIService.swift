//
//  RetrospectAPIService.swift
//  Runner-be
//
//  Created by 이유리 on 2023/01/24.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class RetrospectAPIService {
    private var disposableId: Int = 0
    private var disposableDic: [Int: Disposable] = [:]

    let provider: MoyaProvider<RetrospectAPI>
    let loginKeyChain: LoginKeyChainService

    init(provider: MoyaProvider<RetrospectAPI> = .init(), loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        loginKeyChain = loginKeyChainService
        self.provider = provider
    }

    func getRetrospectTab() -> Observable<APIResult<RetrospectInfo?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.getRetrospectTab(token: token))
            .asObservable() // return type을 observable로
            .mapResponse()
            .map { (try? $0?.json["result"].rawData()) ?? Data() } // result에 해당하는 rawData
            .decode(type: RetrospectInfo?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요")) // error 발생시 error observable return
    }
}
