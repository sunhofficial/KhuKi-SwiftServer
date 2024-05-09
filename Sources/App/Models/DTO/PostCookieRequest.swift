//
//  File.swift
//  
//
//  Created by 235 on 5/9/24.
//

import Vapor
struct PostCookieRequest: Content {
    var info: String
    var type: Int
    var gender: String
}
