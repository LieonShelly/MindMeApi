//
//  Aggrement.swift
//  App
//
//  Created by lieon on 2018/4/9.
//

import Foundation
import Vapor

final class Aggrement {
    var relatedUser:User?
    var them: String?
    var startTime: String?
    var endTime: String?
    var punismentArray: [String]?
    var userId: Identifier?
    var currentScore: Int = 100
}
