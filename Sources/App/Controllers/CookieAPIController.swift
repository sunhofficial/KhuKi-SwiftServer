//
//  File.swift
//  
//
//  Created by 235 on 4/13/24.
//

import Foundation
import Vapor
import Fluent

struct CookieAPIController {
    func getAllCookies(req: Request) async throws -> [Cookie] {
        let user = try req.auth.require(User.self)
        let genderFilter = user.gender == "man" ? "girl" : "man"
        return try await Cookie.query(on: req.db)
            .filter(\.$gender == genderFilter)
            .all()
    }
}
extension CookieAPIController: RouteCollection {
    func boot(routes:RoutesBuilder) throws {
        routes.get( use: getAllCookies)
    }
    
    
}
