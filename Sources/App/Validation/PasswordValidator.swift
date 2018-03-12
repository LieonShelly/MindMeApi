//
//  PasswordValidator.swift
//  App
//
//  Created by lieon on 2018/3/12.
//

import Vapor
import HTTP
import VaporValidation
import Crypto

final class PasswordValidator: Validator {
    typealias Input = String
    private let pattern = "^[a-zA-Z0-9]{6,20}+$"
    
    public init() {}
    public func validate(_ input: String) throws {
        guard input.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil else {
            throw error("\(input) is not a valid password")
        }
    }
}
