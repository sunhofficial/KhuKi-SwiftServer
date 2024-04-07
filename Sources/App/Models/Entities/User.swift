//
//  File.swift
//  
//
//  Created by 235 on 3/26/24.
//

import Foundation
import Vapor
import Fluent

final class User : Model, Content {
    static let schema: String = "users"
    init() {

    }
    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String
    @Field(key: "appleUserIdentifier")
    var appleUserIdentifier: String?
    @Field(key: "firstName")
    var firstName: String?

    @Field(key: "lastName")
    var lastName: String?
//    @Field(key: "gender")
//    var gender: String?
//
//    @Field(key: "age")
//    var age: Int?
//
//    @Field(key: "distance")
//    var distance: Int?
//
//    @Field(key: "openID")
//    var openId: String?
//
//    @Field(key: "restraunt")
//    var restraunt: String?
//
//    @Field(key: "selfInfo")
//    var selfInfo: String?


    init(
      id: UUID? = nil,
      email: String,
      firstName: String? = nil,
      lastName: String? = nil,
      appleUserIdentifier: String
    ) {
      self.id = id
      self.email = email
      self.firstName = firstName
      self.lastName = lastName
      self.appleUserIdentifier = appleUserIdentifier
    }
//    init(id: UUID? = nil, email: String, gender: String, age: Int, distance: Int, openId: String, restraunt: String, selfInfo: String) {
//        self.id = id
//        self.gender = gender
//        self.age = age
//        self.email = email
//        self.distance = distance
//        self.openId = openId
//        self.restraunt = restraunt
//        self.selfInfo = selfInfo
//    }

}
extension User: Authenticatable {
  struct Public: Content {
    let id: UUID
    let email: String
    let firstName: String?
    let lastName: String?

    init(user: User) throws {
      self.id = try user.requireID()
      self.email = user.email
      self.firstName = user.firstName
      self.lastName = user.lastName
    }
  }

  func asPublic() throws -> Public {
    try .init(user: self)
  }
}

// MARK: - Token Creation
extension User {
  func createAccessToken(req: Request) throws -> Token {
    let expiryDate = Date() + ProjectConfig.AccessToken.expirationTime
    return try Token(
      userID: requireID(),
      token: [UInt8].random(count: 32).base64,
      expiresAt: expiryDate
    )
  }
}

// MARK: - Helpers
extension User {
  static func assertUniqueEmail(_ email: String, req: Request) async throws {
      guard let user = try await findByEmail(email, req: req) else {
          throw UserError.emailTaken
    }
//return true
  }

  static func findByEmail(_ email: String, req: Request) async throws -> User? {
    return try await User.query(on: req.db)
      .filter(\.$email == email)
      .first()
  }

  static func findByAppleIdentifier(_ identifier: String, req: Request) async throws -> User? {
    return try await User.query(on: req.db)
      .filter(\.$appleUserIdentifier == identifier)
      .first()
  }
}

