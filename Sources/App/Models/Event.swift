//
//  Event.swift
//  MindMeApiPackageDescription
//
//  Created by lieon on 2018/3/7.
//

import Vapor
import FluentProvider
import HTTP

final class Event: Model {
    let storage: Storage = Storage()
    var title: String
    var content: String
    var mindTime: String
    var userId: Identifier?
    
    struct Keys {
        static let id = "id"
        static let title = "title"
        static let content = "content"
        static let mindTime = "mindTime"
        static let tileUserId = "user_id"
    }
    
    init(title: String,
         content: String,
         mindTime: String,
         user: User) {
        self.title = title
        self.content = content
        self.mindTime = mindTime
        self.userId = user.id
    }
    
    
    init(row: Row) throws {
        title = try row.get(Event.Keys.title)
        content = try row.get(Event.Keys.content)
        mindTime = try row.get(Event.Keys.mindTime)
        userId = try row.get(User.foreignIdKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Event.Keys.title, title)
        try row.set(Event.Keys.content, content)
        try row.set(Event.Keys.mindTime, mindTime)
             try row.set(User.foreignIdKey, userId)
        return row
    }
}

extension Event: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Event.Keys.title)
            builder.string(Event.Keys.content)
            builder.string(Event.Keys.mindTime)
            builder.parent(User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Event: JSONConvertible {
    convenience init(json: JSON) throws {
        let userId: Identifier = try json.get("user_id")
        guard let user = try User.find(userId) else {
            throw Abort.badRequest
        }
        self.init(title: try json.get(Event.Keys.title),
                  content: try json.get(Event.Keys.content),
                  mindTime:  try json.get(Event.Keys.mindTime),
                  user: user)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Event.Keys.id, id)
        try json.set(Event.Keys.content, content)
        try json.set(Event.Keys.title, title)
        try json.set(Event.Keys.mindTime, mindTime)
          try json.set(Event.Keys.tileUserId, userId)
        return json
    }
}

extension Event: ResponseRepresentable {}

extension Event: Updateable {
    static var updateableKeys: [UpdateableKey<Event>] {
        return [
            UpdateableKey(Event.Keys.content, String.self) { event, content in
                event.content = content
            },
            UpdateableKey(Event.Keys.title, String.self) { event, title in
                event.title = title
            },
            UpdateableKey(Event.Keys.mindTime, String.self) { event, mindTime in
                event.mindTime = mindTime
            },
            UpdateableKey(Event.Keys.tileUserId, Identifier.self) { event, tileUser in
                event.userId = tileUser
            }
        ]
    }
}

extension Event {
    var user: Parent<Event, User> {
        return parent(id: userId)
    }
}


