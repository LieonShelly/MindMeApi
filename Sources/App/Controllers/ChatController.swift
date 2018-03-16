//
//  ChatController.swift
//  MindMeApiPackageDescription
//
//  Created by lieon on 2018/3/15.
//

import Foundation
import Vapor
import HTTP
import Crypto

final class ChatController {
    func addRoutes(_ drop: Droplet) {
           let chatGroup = drop.grouped("rc")
    }
    
    fileprivate func getToken(_ request: Request)  throws -> ResponseRepresentable {
          let nonce: String =  String(arc4random())
          let appSecret = ""// Common.RongCloud.appSecret
          let timStamp = String(NSDate().timeIntervalSince1970)
          var sha1 =  nonce + appSecret + timStamp
         let sha = Sha1
        let hash = CryptoHasher
    }
}

extension ChatController {
   
}
