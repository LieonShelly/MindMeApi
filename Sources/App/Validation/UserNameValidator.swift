//
//  UserNameValidator.swift
//  App
//
//  Created by lieon on 2018/3/12.
//

import Vapor
import HTTP
import VaporValidation
import Crypto

final class UserNameValidator: Validator {
    public init() {}
    
    typealias Input = String
    
    func validate(_ input: String) throws {
        try input.validated(by: EmailValidator())
    }
    
    
}
