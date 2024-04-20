//
//  File.swift
//
//
//  Created by 235 on 4/11/24.
//

import Foundation
import Vapor
import Fluent
final class Cookie: Model, Content {
    static let schema = "cookie"
    init() {}
    @ID(key: .id)
    var id: UUID?
    
//    @Parent(key: "userID")
//    var user: User

    @Field(key: "info")
    var info: String

    @Field(key: "type")
    var type: Int

    @Field(key: "gender")
    var gender: String
    // User ID를 저장할 옵셔널 필드 추가
//

    init(id: UUID? = nil, info: String, type: Int, gender: String) {
        self.id = id
        self.info = info
//        self.userID = userID
        self.type = type
        self.gender = gender
    }
}

struct UpdateCookie: Codable {
    var info: String
    var type: Int
}
