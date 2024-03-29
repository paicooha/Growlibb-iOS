//
//  MyPageAPIService.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class MyPageAPIService {
    private var disposableId: Int = 0
    private var disposableDic: [Int: Disposable] = [:]

    let provider: MoyaProvider<MyPageAPI>
    let loginKeyChain: LoginKeyChainService

    init(provider: MoyaProvider<MyPageAPI> = .init(plugins: [MoyaPlugin(verbose: true)]), loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        loginKeyChain = loginKeyChainService
        self.provider = provider
    }

    func getMyPage() -> Observable<APIResult<MyPage?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.getMyPage(token: token))
            .asObservable() // return type을 observable로
            .mapResponse()
            .map { (try? $0?.json["result"].rawData()) ?? Data() } // result에 해당하는 rawData
            .decode(type: MyPage?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요")) // error 발생시 error observable return
    }
    
    func patchAlarm(fcmToken: String?) -> Observable<APIResult<BaseResponse?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.patchAlarm(request: PatchFcmRequest(fcmToken: fcmToken), token: token))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json.rawData() ?? Data() }
            .decode(type: BaseResponse?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
    func patchPhoneNumber(request: PostCheckPhoneRequest) -> Observable<APIResult<BaseResponse?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.patchPhone(request: request, token: token))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json.rawData() ?? Data() }
            .decode(type: BaseResponse?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
    func logout() -> Observable<APIResult<BaseResponse?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.logout(token: token))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json.rawData() ?? Data() }
            .decode(type: BaseResponse?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
    func resign(request: ResignReason) -> Observable<APIResult<BaseResponse?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.resign(request: request, token: token))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json.rawData() ?? Data() }
            .decode(type: BaseResponse?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
    func postCheckPassword(request: PostCheckPasswordRequest) -> Observable<APIResult<BaseResponse?>> {

        return provider.rx.request(.postCheckPassword(request: request))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json.rawData() ?? Data() }
            .decode(type: BaseResponse?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
    func patchPassword(request: PatchPasswordRequest) -> Observable<APIResult<BaseResponse?>> {

        return provider.rx.request(.patchPassword(request: request))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json.rawData() ?? Data() }
            .decode(type: BaseResponse?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
    func getRetrospectList(page: Int) ->
        Observable<APIResult<GetRetrospectResult?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.getRetrospectList(page: page, token: token))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json["result"].rawData() ?? nil }
            .decode(type: GetRetrospectResult?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
    func getDetailRetrospect(retrospectionId: Int) ->
        Observable<APIResult<GetDetailRetrospectResult?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.getRetrospectDetail(retrospectionId: retrospectionId, token: token))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json["result"].rawData() ?? nil }
            .decode(type: GetDetailRetrospectResult?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
    func patchRetrospect(request: PatchRetrospectRequest) ->
        Observable<APIResult<BaseResponse?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.patchRetrospect(request: request, token: token))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json.rawData() ?? Data() }
            .decode(type: BaseResponse?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
    func postCheckNickname(request: PostCheckNicknameRequest) -> Observable<APIResult<BaseResponse?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.postCheckNickname(request: request, token: token))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json.rawData() ?? Data() }
            .decode(type: BaseResponse?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
    func getMyProfile() -> Observable<APIResult<MyProfile?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.getProfile(token: token))
            .asObservable() // return type을 observable로
            .mapResponse()
            .map { (try? $0?.json["result"].rawData()) ?? Data() } // result에 해당하는 rawData
            .decode(type: MyProfile?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요")) // error 발생시 error observable return
    }
    
    func patchProfile(request: PatchProfileRequest) ->
        Observable<APIResult<BaseResponse?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.patchProfile(request: request, token: token))
            .asObservable()
            .mapResponse()
            .compactMap { try? $0?.json.rawData() ?? Data() }
            .decode(type: BaseResponse?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
}
