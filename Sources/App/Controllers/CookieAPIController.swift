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
    func getAllCookies(req: Request) async throws -> Page< Cookie> {
        let user = try req.auth.require(User.self)
        let genderFilter = user.gender == "man" ? "girl" : "man"
        let page = (req.query[Int.self, at: "page"] ?? 1)
        return try await Cookie.query(on: req.db)
            .filter(\.$gender == genderFilter)
        //http://localhost:8080/api/v1/models?page=1&per=10
            .paginate(PageRequest(page: page, per: 9))

//            .all()

    }
}
extension CookieAPIController: RouteCollection {
    func boot(routes:RoutesBuilder) throws {
        routes.get( use: getAllCookies)
    }
    
    
}
