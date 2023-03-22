//
//  PatchProfileRequest.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/17.
//

import Foundation

struct PatchProfileRequest: Encodable {
    var profileImageURL, nickname: String
    var gender, birthday, job: String?

    enum CodingKeys: String, CodingKey {
        case profileImageURL = "profileImageUrl"
        case nickname, gender, birthday, job
    }
}
