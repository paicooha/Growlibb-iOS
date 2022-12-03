//
//  HomeDataManager.swift
//  Growlibb
//
//  Created by 이유리 on 2022/12/02.
//

import Foundation
import Alamofire

class HomeDataManager {
    func postLogin(viewController: LoginViewController, email: String, password: String) {
        let parameters = LoginRequest(email: email, password: password)
        AF.request("\(Constants.BASE_URL)auth/v1/sign-in", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
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
    
    func getHome(viewController: HomeViewController, date: String) {
        AF.request("\(Constants.BASE_URL)v1/home?date=\(date)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants().HEADERS)
            .validate()
            .responseDecodable(of: GetHomeResponse.self) { response in
                switch response.result {
                case let .success(response):
                    print(response)
                    if response.isSuccess {
                        viewController.didSuccessGetHome(result: response.result!)
                    } else {
                        viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                    }
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    func patchFcmToken(viewController: AppCoordinator, fcmToken: String) {
        let parameters = PatchFcmRequest(fcmToken: fcmToken)
        
        AF.request("\(Constants.BASE_URL)v1/fcm-token", method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: Constants().HEADERS)
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
