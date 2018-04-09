//
//  User.swift
//  MindMeApiPackageDescription
//
//  Created by lieon on 2018/3/9.
//

import Foundation
import FluentProvider
import HTTP
import Node
import Crypto

final class User: Model, NodeInitializable{
    var storage: Storage = Storage()
    var email: String
    var password: String
    var name: String
//    var id: Node?
    
    struct Keys {
        static let email: String = "email"
        static let id: String = "id"
        static let password: String = "password"
          static let name: String = "name"
    }
 
    init(email: String,
         password: String,
         name: String) {
        self.email = email
        self.password = password
        self.name = name
    }
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.Keys.email, email)
        try row.set(User.Keys.password, password)
       try row.set(User.Keys.name, name)
        return row
    }

    required init(row: Row) throws {
        email = try row.get(User.Keys.email)
        password = try row.get(User.Keys.password)
          name = try row.get(User.Keys.name)
    }

    init(node: Node, in context: Context) throws {
        email = try node.get(User.Keys.email)
        password = try node.get(User.Keys.password)
         name = try node.get(User.Keys.name)
    }
}

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(email: try json.get(User.Keys.email),
                  password: try json.get(User.Keys.password),
                  name: try json.get(User.Keys.name))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(User.Keys.id, id)
        try json.set(User.Keys.email, email)
        try json.set(User.Keys.password, password)
        try json.set(User.Keys.name, name)
        return json
    }
}

extension User: ResponseRepresentable {}

extension User: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        return try Node(node: [
//            User.Keys.id: id,
            User.Keys.email: email,
            User.Keys.name: name,
            User.Keys.password: password
            ])
    }
}

extension User: Preparation {
    
    static func prepare(_ database: Database) throws {
     try   database.create(self) {builder in
            builder.id()
            builder.string(User.Keys.email)
            builder.string(User.Keys.password)
         builder.string(User.Keys.name)
        }
    }
    
    static func revert(_ database: Database) throws {
      try  database.delete(self)
    }
}

extension User {
    var events: Children<User, Event> {
        return children()
    }
}
