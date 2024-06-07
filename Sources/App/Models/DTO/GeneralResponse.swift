//
//  File.swift
//  
//
//  Created by 235 on 4/21/24.
//

import Vapor
struct GeneralResponse<T: Content>: Content {
    var status: Int
    var message: String
    var data: T?
}
struct VoidContent: Content {
}
