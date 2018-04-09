//
//  DeductionHistory.swift
//  App
//
//  Created by lieon on 2018/4/9.
//

import Foundation
import Vapor

final class DeductionHistory {
    var score: Int = 0
    var reason: String?
    var decutonTime: String?
    var userId: Identifier?
    var excutionUserId: Identifier?
}
