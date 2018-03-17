//
//  Token.swift
//  MindMeApiPackageDescription
//
//  Created by lieon on 2018/3/9.
//

import Foundation
import Vapor
import HTTP
import FluentProvider

final class Token: Model {
    let storage: Storage = Storage()
    let token: String
    let userId: Identifier?

    struct Keys {
        static let token: String = "token"
        static let userId: String = "user_id"
    }
    
    init(token: String, user: User) {
        self.token = token
        self.userId = user.id;
    }
    
    init(row: Row) throws {
        token = try row.get(Token.Keys.token)
        userId = try row.get(User.foreignIdKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Token.Keys.token, token)
        try row.set(User.foreignIdKey, userId)
        return row
    }
}

extension Token: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Token.Keys.token)
            builder.parent(User.self, unique: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}


extension Token {
    var user: Parent<Token, User> {
        return parent(id: userId)
    }
}
