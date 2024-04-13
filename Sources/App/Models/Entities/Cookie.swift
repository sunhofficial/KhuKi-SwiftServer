//
//  File.swift
//
//
//  Created by 235 on 4/11/24.
//

import Foundation
import Vapor
import Fluent
final class Cookie: Model {
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
       @OptionalField(key: "userID")
       var userID: UUID?

    init(info: String,userID: UUID?, type: Int, gender: String) {
        self.info = info
        self.userID = userID
        self.type = type
        self.gender = gender
    }
}
