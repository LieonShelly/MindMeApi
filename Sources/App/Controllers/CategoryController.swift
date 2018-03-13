//
//  CategoryController.swift
//  App
//
//  Created by lieon on 2018/3/13.
//

import Vapor
import FluentProvider

final class CategoryController {
    func addRoutes(to drop: Droplet) {
        let categoryGroup = drop.grouped("categories")
        categoryGroup.get(handler: allCategories)
        categoryGroup.post("create", handler: createCategory)
        categoryGroup.get(Category.parameter, handler: getCategory)
         categoryGroup.get(Category.parameter, "events", handler: getCategoryEvents)
    }
    
    func createCategory(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        let category = try Category(json: json)
        try category.save()
        return category
    }
    
    func allCategories(_ req: Request) throws -> ResponseRepresentable {
        let categories = try Category.all()
        return try categories.makeJSON()
    }
    
    func getCategory(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.parameters.next(Category.self)
        return category
    }
    func getCategoryEvents(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.parameters.next(Category.self)
        return try category.events.all().makeJSON()
    }
}
