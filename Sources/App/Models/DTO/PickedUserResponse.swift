//
//  File.swift
//  
//
//  Created by 235 on 5/10/24.
//

import Vapor

struct PickedUserResponse: Content {
    var age: Int
    var distance: Int
    var restarunat: String
    var info: String
    var type: Int
    var openId: String
    var selfInfo: String
}
