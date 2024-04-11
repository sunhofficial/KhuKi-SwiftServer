//
//  File.swift
//  
//
//  Created by 235 on 4/3/24.
//
import Fluent
import JWT
import Vapor

struct SIWAAPIController {

  struct SIWARequestBody: Content {
    let appleIdentityToken: String
  }

    func authHandler(req: Request) async throws -> UserResponse {
      let userBody = try req.content.decode(SIWARequestBody.self)
      let appleIdentityToken = try await req.jwt.apple.verify(
        userBody.appleIdentityToken,
        applicationIdentifier: ProjectConfig.SIWA.applicationIdentifier
      )
        
      if let user = try await User.findByAppleIdentifier(appleIdentityToken.subject.value, req: req) {
        return try await SIWAAPIController.signIn(
          appleIdentityToken: appleIdentityToken,
          req: req
        )
      } else {
        return try await SIWAAPIController.signUp(
          appleIdentityToken: appleIdentityToken,
          req: req
        )
      }
    }
    static func signUp(
      appleIdentityToken: AppleIdentityToken,
      req: Request
    ) async throws -> UserResponse {
      guard let email = appleIdentityToken.email else {
        throw UserError.siwaEmailMissing
      }

//      try await User.assertUniqueEmail(email, req: req)

      let user = User(
        email: email,
        appleUserIdentifier: appleIdentityToken.subject.value
      )

      try await user.save(on: req.db)
      guard let accessToken = try? user.createAccessToken(req: req) else {
        throw Abort(.internalServerError)
      }

      try await accessToken.save(on: req.db)
      return try .init(accessToken: accessToken, user: user)
    }
    
    static func signIn(
      appleIdentityToken: AppleIdentityToken,
      req: Request
    ) async throws -> UserResponse {
        guard let user = try await User.findByAppleIdentifier(appleIdentityToken.subject.value, req: req) else {
            throw UserError.siwaInvalidState
        }
//        if let email = appleIdentityToken.email {
//        user.email = email
//        try await user.update(on: req.db)
//      }
        var accessToken: Token
        let existingToken = try await Token.query(on: req.db)
            .filter(\.$user.$id == user.id! ) // User 모델과 연관된 키를 사용하여 필터
            .first()
        let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        if let existingToken = existingToken, let expiresAt = existingToken.expiresAt, expiresAt < sevenDaysLater {
            accessToken = try user.createAccessToken(req: req)
            try await accessToken.save(on: req.db)
        } else {
            accessToken = existingToken!
        }
        return try .init(accessToken: accessToken, user: user)
    }
    
}

// MARK: - RouteCollection
extension SIWAAPIController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.post(use: authHandler)
  }
}
