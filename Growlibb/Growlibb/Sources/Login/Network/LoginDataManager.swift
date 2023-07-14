//
//  LoginDataManager.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation
import Alamofire

class LoginDataManager {
    func postLogin(viewController: LoginViewController, email: String, password: String) {
        let parameters = LoginRequest(email: email, password: password)
        AF.request("\(Secret.BASE_URL)auth/v1/sign-in", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: PostLoginResponse.self) { response in
                switch response.result {
                case let .success(response):
                    if response.isSuccess {
                        viewController.didSuccessLogin(result: response.result!)

                    } else {
                        viewController.didFailLogin()
                    }
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    func checkJwt(viewController: AppCoordinator) {
        AF.request("\(Secret.BASE_URL)auth/v1/jwt", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants().HEADERS)
            .validate()
            .responseDecodable(of: GetJwtResponse.self) { response in
                switch response.result {
                case let .success(response):
                    print(response)
                    if response.isSuccess {
                        viewController.didSuccessGetJwt(result: response.result!)
                    } else {
                        viewController.didFailgetJwt()
                    }
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    func patchFcmToken(viewController: AppCoordinator, _ fcmToken: String) {
        let parameters = PatchFcmRequest(fcmToken: fcmToken)
        
        AF.request("\(Secret.BASE_URL)v1/fcm-token", method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: Constants().HEADERS)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    viewController.didSuccessPatchFcmToken(code: response.code)
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
}
