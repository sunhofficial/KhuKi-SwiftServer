//
//  File.swift
//  
//
//  Created by 235 on 4/8/24.
//

import Vapor
struct ProfileUpdateRequestFirst: Content {
    var gender: String
    var age: Int
    var distance: Int
}

