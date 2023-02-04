//
//  WriteRetrospectAPIService.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/01.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class WriteRetrospectAPIService {
//    private var disposableId: Int = 0
//    private var disposableDic: [Int: Disposable] = [:]

    let provider: MoyaProvider<WriteRetrospectAPI>
    let loginKeyChain: LoginKeyChainService

    init(provider: MoyaProvider<WriteRetrospectAPI> = .init(), loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        loginKeyChain = loginKeyChainService
        self.provider = provider
    }
    
    func postRetrospect(request: PostRetrospectRequest) -> Observable<APIResult<PostRetrospectResult?>> {
        let token = (loginKeyChain.token)!

        return provider.rx.request(.postRetrospect(request: request, token: token))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json["result"].rawData() ?? Data() }
            .decode(type: PostRetrospectResult?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
}
