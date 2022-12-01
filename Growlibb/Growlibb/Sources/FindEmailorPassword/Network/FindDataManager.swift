//
//  FindDataManager.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/30.
//

import Foundation
import Alamofire

class FindDataManager {
    func postFindEmail(viewController: FindEmailorPasswordViewController, phoneNumber: String) {
        let parameters = PostFindEmailRequest(phoneNumber: phoneNumber)
        AF.request("\(Constants.BASE_URL)auth/v1/search-email", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: PostFindEmailResponse.self) { response in
                switch response.result {
                case let .success(response):
                    viewController.didSuccessFindEmail(response: response)
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    func postFindPassword(viewController: FindEmailorPasswordViewController, phoneNumber: String, email: String) {
        let parameters = PostFindPasswordRequest(phoneNumber: phoneNumber, email: email)
        AF.request("\(Constants.BASE_URL)auth/v1/check-password", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    viewController.didSuccessFindPassword(code: response.code)
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    func postpatchPassword(viewController: FindEmailorPasswordViewController, userInfo:UserInfo) {
        let parameters = PatchResetPasswordRequest(phoneNumber: userInfo.phoneNumber, email: userInfo.email, password: userInfo.password, confirmPassword: userInfo.password)
        AF.request("\(Constants.BASE_URL)auth/v1/password", method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    viewController.didSuccessPatchPassword(code: response.code)
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
}
