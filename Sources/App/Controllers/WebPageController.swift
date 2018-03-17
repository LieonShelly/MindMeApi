//
//  WebPageController.swift
//  App
//
//  Created by lieon on 2018/3/15.
//

import Foundation
import Vapor


final class WebPageController {
    func addRoutes(_ drop: Droplet) {
        let webPageGroup = drop.grouped("web")
        webPageGroup.get { request -> ResponseRepresentable in
            return try drop.view.make("MindMe/index.html")
        }
    }
    
    
}

