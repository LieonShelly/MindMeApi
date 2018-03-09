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

final class User: Model, NodeInitializable {
    var storage: Storage = Storage()
    var email: String
    var password: String
    var id: Node?
    
    struct Keys {
        static let email: String = "email"
        static let id: String = "id"
        static let password: String = "password"
    }
 
    init(email: String,
         password: String) {
        self.email = email
        self.password = password
    }
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.Keys.email, email)
        try row.set(User.Keys.password, password)
        return row
    }
    
    required init(row: Row) throws {
        email = try row.get(User.Keys.email)
        password = try row.get(User.Keys.password)
    }
    
    init(node: Node) throws {
        id = try node.get(User.Keys.id)
        email = try node.get(User.Keys.email)
        password = try node.get(User.Keys.password)
    }
}

extension User: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set(Keys.email, email)
        try node.set(Keys.password, password)
        return node
    }
}

extension User: Preparation {
    
    static func prepare(_ database: Database) throws {
     try   database.create(self) {builder in
            builder.id()
            builder.string(User.Keys.id)
            builder.string(User.Keys.email)
            builder.string(User.Keys.password)
        }
    }
    
    static func revert(_ database: Database) throws {
      try  database.delete(self)
    }
}
