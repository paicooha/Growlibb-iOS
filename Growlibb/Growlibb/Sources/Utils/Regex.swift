//
//  Regex.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/21.
//

import Foundation

class Regex {
    
    // 이메일 정규성 체크
    func isValidEmail(input: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: input)
    }
    
    // 패스워드 정규성 체크
    func isValidPassword(input: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}" // 8자리 ~ 20자리 영어+숫자+특수문자
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: input)
        
    }
    
    func isValidBirthday(input: String) -> Bool {
        let regex = "(19|20)\\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: input)
    }
}
