import Fluent
import JWT
import Vapor

struct UserAPIController {
  func getMeHandler(req: Request) throws -> UserResponse {
    let user = try req.auth.require(User.self)
    return try .init(user: user)
  }
}

// MARK: - RouteCollection
extension UserAPIController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.get("me", use: getMeHandler)
  }
}
