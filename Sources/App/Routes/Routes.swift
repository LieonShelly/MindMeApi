import Vapor
import Node
import PostgreSQLProvider
import PostgreSQLDriver

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
        get("description") { req in return req.description }
 
        try resource("posts", PostController.self)
        let web = WebPageController()
        web.addRoutes(self)
        let basic = BaseController()
        basic.adddRoutes(self)
        let event = EventController()
        event.addRoutes(self)
        let user = UserController()
        user.addRoutes(self)
        let category = CategoryController()
        category.addRoutes(to: self)
        
    }
}
