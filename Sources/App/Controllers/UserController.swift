//
//  UserController.swift
//  MindMeApiPackageDescription
//
//  Created by lieon on 2018/3/12.
//

import Vapor
import HTTP
import VaporValidation
import Crypto
import JWTProvider
import JWT
import Foundation

final class  UserController {
    var drop: Droplet?
    
    func addRoutes(_ drop: Droplet) {
        self.drop = drop
        let userGroup = drop.grouped("user")
        userGroup.post("login", handler: login)
        userGroup.post("register", handler: register)
        userGroup.get(handler: allUser)
        userGroup.get(User.parameter, handler: getUser)
        userGroup.get(User.parameter, "events", handler: getUserEvents)
    }
    
   fileprivate func login(_ request: Request)  throws -> ResponseRepresentable {
        let currentUser = try request.user()
        let email = currentUser.email
        let password = currentUser.password
        try  email.validated(by: UserNameValidator())
        try  password.validated(by: PasswordValidator())
        if let dataBaseUser = try User.makeQuery().filter(User.Keys.email, email).all().first {
            return try JSON(node: [
                        "token": self.drop?.createToken(email) ?? "",
                        "user":  dataBaseUser.makeNode(in: nil)
                    ])
        } else {
            return "not Exist \(email)"
        }
    }
    
    fileprivate func register(_ request: Request) throws -> ResponseRepresentable {
        let currentUser = try request.user()
        let email = currentUser.email
        let password = currentUser.password
        try  email.validated(by: UserNameValidator())
        try  password.validated(by: PasswordValidator())
        if let _ = try User.makeQuery().filter(User.Keys.email, email).all().first {
           return "Exist \(email)"
        } else {
           try currentUser.save()
          return currentUser
        }
    }
    
    fileprivate func allUser(_ request: Request) throws -> ResponseRepresentable {
        let users = try User.all()
        let token = request.headers[HeaderKey.init("token")]
        try self.drop?.validateToken(token!)
        return try users.makeJSON()
    }
    
    fileprivate func getUser(_ request: Request) throws -> ResponseRepresentable {
        let user = try request.parameters.next(User.self)
        return user
    }
    
    fileprivate func getUserEvents(_ request: Request) throws -> ResponseRepresentable  {
        let user = try request.parameters.next(User.self)
        return try user.events.all().makeJSON()
    }
}

extension Request {
    func user() throws -> User {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try User(json: json)
    }
}
