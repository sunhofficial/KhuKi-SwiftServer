//
//  File.swift
//  
//
//  Created by 235 on 6/7/24.
//

import Vapor
struct ProfileUpdateRequestSecond: Content {
    var openId: String
    var restaruant: String
    var selfInfo: String
}

