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
    func getAllCookies(req: Request) async throws -> GeneralResponse<Page<GetCookiesResponse>> {
        let user = try req.auth.require(User.self)
        let genderFilter = user.gender == "man" ? "girl" : "man"
        let page = (req.query[Int.self, at: "page"] ?? 1)
        let haveMyCookie = try await Cookie.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .count()
        if haveMyCookie > 0 {
            let data =  try await Cookie.query(on: req.db)
                .filter(\.$gender == genderFilter)
                .with(\.$user)
            //http://localhost:8080/api/v1/models?page=1&per=10
                .paginate(PageRequest(page: page, per: 9)).map { page in
                    GetCookiesResponse(age: page.user.age!, distance: page.user.distance!, restarunat: page.user.restaruant!, info: page.info, type: page.type)
                }
            if data.items.isEmpty    {
                return GeneralResponse(status: 400  , message: "No Cookies yet",data: data)
            }
            else {return GeneralResponse(status: 200, message: "success",data: data)}
        } else {
            throw CookieError.noMyCookie
        }
    }
    func postPickCookie(req: Request) async throws -> GeneralResponse<PostPickResponse> {
        guard let cookieIDString = try? await req.content.get(String.self, at: "id"),
              let cookieID = UUID(uuidString: cookieIDString) else {
            throw Abort(.badRequest, reason: "Invalid or missing cookie ID.")
        }
        let pickuser = try req.auth.require(User.self)
        if let lastPickTime = pickuser.lastPicked {
            if Date().timeIntervalSince(lastPickTime) < 86400 {
                throw CookieError.alreadyPicked
            }
        }
        guard let cookieItem = try await Cookie.query(on: req.db)
            .filter(\._$id == cookieID)
            .first()
        else {
            throw Abort(.notFound)
        }
        guard let pickeduser = try await User.query(on: req.db)
            .filter(\._$id == cookieID)
            .first() else {
            throw Abort(.notFound)
        }
        if let pickeduserCookie = pickeduser.myCookie {
            pickuser.pickedCookies = (pickuser.pickedCookies ?? []) + [pickeduserCookie]
        }

        guard let openID = pickeduser.openId, let selfInfo = pickeduser.selfInfo else {
            throw Abort(.internalServerError)
        }
        try await cookieItem.delete(on: req.db)
//        pickeduser.myCookie = nil
        pickuser.lastPicked = Date()
        try await pickuser.update(on: req.db)
        try await pickeduser.update(on: req.db)
        return GeneralResponse(status: 200, message: "success", data: PostPickResponse(openID: openID, selfInfo: selfInfo))
    }
}
extension CookieAPIController: RouteCollection {
    func boot(routes:RoutesBuilder) throws {
        routes.get( use: getAllCookies)
        routes.post("pick", use: postPickCookie)
    }

}
