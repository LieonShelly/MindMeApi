//
//  BaseController.swift
//  MindMeApiPackageDescription
//
//  Created by lieon on 2018/3/12.
//

import Vapor
import Node
import PostgreSQLProvider
import PostgreSQLDriver
import ValidationProvider
import VaporValidation

final class BaseController {
    func adddRoutes(_ drop: Droplet) {
        let group = drop.grouped("basic")
        
        group.get("version") { (request) -> ResponseRepresentable in
            if let driver = drop.database?.driver {
                 let version = try driver.raw("SELECT version()")
                return JSON(node: version)
            } else {
                return "NO DataBase Connection"
            }
        }
        
         group.get("all") { req in
            return try JSON(node: User.all().makeNode(in: nil))
            
        }
         group.get("first") {req  in
            return try JSON(node: User.makeQuery().first()?.makeNode(in: nil))
            
        }
         group.get("afk") { req in
            return try JSON(node: User.makeQuery().filter("email", "lieoncx@gmail.com").all().makeNode(in: nil))
            
        }
        group.get("not0-afk") { req in
            return try JSON(node: User.makeQuery().filter("email", .notEquals, "lieoncx@gmail.com") .all().makeNode(in: nil))
        }
        group.get("update") { req in
            guard let  fist = try User.makeQuery().first(),
                let emali = req.data["email"]?.string else {
                    throw Abort.badRequest
            }
            fist.email = emali
            try  fist.save()
            return fist
            
        }
        group.post("new") { req in
            let user = try User(node: req.json)
            try user.save()
            return user
            
        }
        group.get("aphla") { req in
            guard  let alpha = req.data["alpha"]?.string  else {
                throw Abort.badRequest
            }
          try  alpha.validated(by: OnlyAlphanumeric())
           
            return ""
        }
    }
    
  
}

class Match: Validator {
    typealias Input = String
    
    func validate(_ input: String) throws {
        
    }
    

}
