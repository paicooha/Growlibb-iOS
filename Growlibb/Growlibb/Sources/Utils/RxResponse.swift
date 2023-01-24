//
//  RxResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/24.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

extension ObservableType where Element: Response {
    func mapJSON() -> Observable<JSON?> {
        return map { response in
            try? JSON(data: response.data)
        }
    }

    func mapResponse() -> Observable<(basic: BasicResponse, json: JSON)?> {
        return map { response -> (basic: BasicResponse, json: JSON)? in
            guard let json = try? JSON(data: response.data),
                  let basicResponse = try? BasicResponse(json: json)
            else {
                Log.d(tag: .network, "result: nil")
                return nil
            }

            Log.d(tag: .network, "isSuccess: \(basicResponse.isSuccess), code: \(basicResponse.code), message: \(basicResponse.message)\nresult: \n\(json)")
            return (basic: basicResponse, json: json)
        }
    }
}
