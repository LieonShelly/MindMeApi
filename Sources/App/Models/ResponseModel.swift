//
//  ResponseModel.swift
//  MindMeApiPackageDescription
//
//  Created by lieon on 2018/3/19.
//

import Foundation
import Vapor
import Node

class ResponseModel: NodeInitializable {
    var code: Int = 0
    var data: Node?
    var desc: String
    var token: String?
    
    init(code: Int,
         desc: String,
         token: String? = nil,
         data: Node = nil) {
        self.code = code
        self.data = data
        self.desc = desc
        self.token = token
    }
    
    required init(node: Node) throws {
        code = try node.get("code")
        data = try node.get("data")
        desc = try node.get("desc")
        token = try node.get("token")
    }
    
}

extension ResponseModel: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        return try Node(node: [
            "code": code,
            "data": data  ?? [String: Any](),
            "desc": desc,
            "token": token ?? ""
            ])
    }
}

