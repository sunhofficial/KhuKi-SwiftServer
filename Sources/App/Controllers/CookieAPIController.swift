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
    func getAllCookies(req: Request) async throws -> GeneralResponse<Page<Cookie>> {
        let user = try req.auth.require(User.self)
        let genderFilter = user.gender == "man" ? "girl" : "man"
        let page = (req.query[Int.self, at: "page"] ?? 1)
        let data =  try await Cookie.query(on: req.db)
            .filter(\.$gender == genderFilter)
        //http://localhost:8080/api/v1/models?page=1&per=10
            .paginate(PageRequest(page: page, per: 9))
        if data.items.isEmpty {
            return GeneralResponse(status: 401, message: "no Cookie yet")
        }
        else {
            return GeneralResponse(status: 200, message: "success", data: data)
        }
    }
    func postPickCookie(req: Request) async throws -> GeneralResponse<PostPickResponse> {
        guard let cookieIDString = try? await req.content.get(String.self, at: "id"),
                 let cookieID = UUID(uuidString: cookieIDString) else {
               throw Abort(.badRequest, reason: "Invalid or missing cookie ID.")
           }

        guard let user = try await User.query(on: req.db)
            .filter(\._$id == cookieID)
            .first() else {
            throw Abort(.notFound)
        }

        guard let openID = user.openId, let selfInfo = user.selfInfo else {
            throw Abort(.internalServerError)
        }
        user.myCookie = nil
       try await user.update(on: req.db)
        return GeneralResponse(status: 200, message: "success", data: PostPickResponse(openID: openID, selfInfo: selfInfo))
    }
}
extension CookieAPIController: RouteCollection {
    func boot(routes:RoutesBuilder) throws {
        routes.get( use: getAllCookies)
        routes.post("pick", use: postPickCookie)
    }
    


}
