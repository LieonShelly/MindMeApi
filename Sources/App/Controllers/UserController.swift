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

final class  UserController {
    func addRoutes(_ drop: Droplet) {
        let userGroup = drop.grouped("user")
        userGroup.post("login", handler: login)
        userGroup.post("register", handler: register)
    }
    
   fileprivate func login(_ request: Request)  throws -> ResponseRepresentable {
        let currentUser = try request.user()
        let email = currentUser.email
        if let dataBaseUser = try User.makeQuery().filter(User.Keys.email, email).all().first {
            return try JSON(node: dataBaseUser.makeNode(in: nil))
        } else {
            return "not Exist \(email)"
        }
    }
    
    fileprivate func register(_ request: Request) throws -> ResponseRepresentable {
        let currentUser = try request.user()
        let email = currentUser.email
        if let _ = try User.makeQuery().filter(User.Keys.email, email).all().first {
           return "Exist \(email)"
        } else {
           try currentUser.save()
          return currentUser
        }
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
