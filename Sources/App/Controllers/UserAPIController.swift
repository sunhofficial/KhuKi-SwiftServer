import Fluent
import JWT
import Vapor

struct UserAPIController {
//  func getMeHandler(req: Request) throws -> UserResponse {
//    let user = try req.auth.require(User.self)
//    return try .init(user: user)
//  }
    func updatefirstProfile(req: Request) async throws -> User {
        let user = try req.auth.require(User.self)
        let updateRequest = try req.content.decode(ProfileUpdateRequestFirst.self)
        user.gender = updateRequest.gender
        user.age = updateRequest.age
        user.distance = updateRequest.distance
        try await user.save(on: req.db)
        return user
    }
    func updateSecondProfile(req: Request) async throws -> User {
        let user = try req.auth.require(User.self)
        let updateRequest = try req.content.decode(ProfileUpdateRequestSecond.self)
        user.openId = updateRequest.openId
        user.restaruant = updateRequest.restaruant
        user.selfInfo = updateRequest.selfInfo
        try await user.save(on: req.db)
        return user
    }
    func deleteUser(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        try await user.delete(on: req.db)
        return .ok
    }
    func postCookie(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let postRequest = try req.content.decode(Cookie.self)
        user.myCookie = postRequest
        let newCookie = Cookie(id:  try user.requireID(),info: postRequest.info,  type: postRequest.type, gender: postRequest.gender)
        try await user.save(on: req.db)
        try await newCookie.save(on: req.db)
        return .ok
    }
    func putCookie(req: Request) async throws -> Cookie {
        let user = try req.auth.require(User.self)
        let putRequest = try req.content.decode(UpdateCookie.self)
        guard let myCookie = try await Cookie.find(user.id, on: req.db) else {
            throw Abort(.notFound, reason: "없어 id가 임마")
        }
        myCookie.info = putRequest.info
        myCookie.type = putRequest.type
//       
        user.myCookie = myCookie
        try await user.update(on: req.db)
        try await myCookie.update(on: req.db)
        return myCookie
    }
    func getPickedCookies(req: Request) async throws -> [Cookie]? {
        let user = try req.auth.require(User.self)
        return user.pickedCookies
    }
}

// MARK: - RouteCollection
extension UserAPIController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
      routes.put("profile","first", use: updatefirstProfile)
      routes.put("profile","second", use: updateSecondProfile)
      routes.delete("delete", use: deleteUser)
      routes.post("cookie", use: postCookie)
      routes.put("cookie", use: putCookie)
//      routes.get("cookie","picked")

  }
}
