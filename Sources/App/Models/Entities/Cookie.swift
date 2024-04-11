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

    @Field(key: "info")
    var info: String

    @Field(key: "type")
    var type: Int
    init(info: String, type: Int) {
        self.info = info
        self.type = type
    }
}
