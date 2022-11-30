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
}
