//
//  SignUpDataManager.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/24.
//

import Foundation
import Alamofire

class SignUpDataManager {
    func postCheckEmail(viewController: SignUpFirstViewController, email: String) {
        let parameters = PostCheckEmailRequest(email: email)
        AF.request("\(Secret.BASE_URL)auth/v1/check-email", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    viewController.didSuccessCheckEmail(code: response.code)
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    func postCheckNickname(viewController: SignUpSecondViewController, nickname: String) {
        let parameters = PostCheckNicknameRequest(nickname: nickname)
        AF.request("\(Secret.BASE_URL)auth/v1/check-nickname", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    viewController.didSuccessCheckNickname(code: response.code)
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    func postCheckPhone(viewController: SignUpFirstViewController, phoneNumber: String) {
        let parameters = PostCheckPhoneRequest(phoneNumber: phoneNumber)
        AF.request("\(Secret.BASE_URL)auth/v1/check-phone-number", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    viewController.didSuccessCheckPhone(code: response.code)
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    func postSignUp(viewController: SignUpSecondViewController) {
        let parameters = PostSignUpRequest(email: UserInfo.shared.email, password: UserInfo.shared.password, phoneNumber: UserInfo.shared.phoneNumber, nickname: UserInfo.shared.nickName, fcmToken: UserInfo.shared.fcmToken, gender: UserInfo.shared.gender, birthday: UserInfo.shared.birthday, job: UserInfo.shared.job)
        AF.request("\(Secret.BASE_URL)auth/v1/sign-up", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: PostSignUpResponse.self) { response in
                switch response.result {
                case let .success(response):
                    if response.isSuccess {
                        viewController.didSuccessSignUp(result: response.result)

                    } else {
                        viewController.failedToRequest(message: "오류가 발생했습니다. 다시 시도해주세요.")
                    }
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
}
