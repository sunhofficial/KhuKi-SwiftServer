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
}

// MARK: - RouteCollection
extension UserAPIController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
      routes.put("firstprofile", use: updatefirstProfile)
      routes.put("secondprofile", use: updateSecondProfile)
  }
}
