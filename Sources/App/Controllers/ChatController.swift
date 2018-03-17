//
//  ChatController.swift
//  MindMeApiPackageDescription
//
//  Created by lieon on 2018/3/15.
//

import Vapor
import HTTP
import Foundation
import PromiseKit
import Crypto

final class ChatController {
    var drop:Droplet?
    func addRoutes(_ drop: Droplet) {
         let chatGroup = drop.grouped("rc")
        chatGroup.get("token") { (req) -> ResponseRepresentable in
            return "getting token"
        }
        chatGroup.post("token") { req -> ResponseRepresentable in
            guard let param = req.json,
                let userId = param["userId"]?.int else {
                return "Param Error"
            }
            do {
               let existToken = try Token.makeQuery().filter(Token.Keys.userId, userId)
               try existToken.delete()
            } catch {
                return "----"
            }
            let nonce: String = String(try Random().makeUInt32())
            let appSecret = Common.RongCloud.appSecret
            let timStamp = String(Int(Date().timeIntervalSince1970))
            let str = (appSecret + nonce + timStamp)
            let sha1 = CryptoHasher(hash: .sha1, encoding: .hex)
            let signature = try sha1.make(str)
            let finalStr = String(bytes: signature)
            let urlStr = Common.RongCloud.getTokenUrl
            let header: [HeaderKey: String] = [
                    HeaderKey("App-Key"):  Common.RongCloud.appkey,
                    HeaderKey("Nonce"): nonce,
                    HeaderKey("Timestamp"): timStamp,
                    HeaderKey("Signature"): finalStr,
                    HeaderKey("Content-Type"): "application/x-www-form-urlencoded",
                   ]
            let req = Request(method: .post, uri: urlStr)
            req.formURLEncoded = try Node(node: param)
            req.headers = header
            let response =  try drop.client.respond(to: req)
            guard let resjson =  response.json,
                let token = resjson["token"]?.string ,
               let user = try User.find(userId)else {
                return "Prase Error"
            }
            let tokenEntity = Token(token: token, user: user)
            try tokenEntity.save()
            return try JSON(node: [
                    "token": token
                ])
        }
        
    }

}

