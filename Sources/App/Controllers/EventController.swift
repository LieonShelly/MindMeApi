//
//  EventController.swift
//  MindMeApiPackageDescription
//
//  Created by lieon on 2018/3/7.
//

import Foundation
import Vapor
import HTTP

final class EventController  {
    func addRoutes(_ drop: Droplet) {
         let eventGroup = drop.grouped("event")
        eventGroup.get("", handler: index)
        eventGroup.post("", handler: store)
        eventGroup.get(Event.parameter, "user", handler: getEventUser)
    }
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Event.all().makeJSON()
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let event = try req.event()
        try event.save()
        return event
    }
    
    func show(_ req: Request, event: Event) throws -> ResponseRepresentable {
        return event
    }
    
    func delete(_ req: Request, event: Event) throws -> ResponseRepresentable {
        try event.delete()
        return Response(status: .ok)
    }
    
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try Event.makeQuery().delete()
        return Response(status: .ok)
    }
    
    func update(_ req: Request, event: Event) throws -> ResponseRepresentable {
        try event.update(for: req)
        try event.save()
        return event
    }
    

    func replace(_ req: Request, event: Event) throws -> ResponseRepresentable {
        let new = try req.event()
        event.content = new.content
        event.title = new.title
        event.mindTime = new.mindTime
        try event.save()
        return event
    }

    func makeResource() -> Resource<Event> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
    
    fileprivate func getEventUser(_ req: Request) throws -> ResponseRepresentable {
        let event = try req.parameters.next(Event.self)
        guard let user = try event.user.get() else {
            throw Abort.notFound
        }
        return user
    }
}

extension Request {
    func event() throws -> Event {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try Event(json: json)
    }
}

extension EventController: EmptyInitializable { }
