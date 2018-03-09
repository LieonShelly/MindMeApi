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

        get("plaintext") { req in
            return "Hello, world!"
        }
        
        post("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }
        
        get("description") { req in return req.description }
        
        get("users") { req in
            return try JSON(node: User.all().makeNode(in: nil))
            
        }
    
        try resource("posts", PostController.self)
        try resource("event", EventController.self)
    }
}
