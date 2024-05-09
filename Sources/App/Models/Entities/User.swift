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

        @OptionalField(key: "gender")
        var gender: String?

        @OptionalField(key: "age") //0->
        var age: Int?

        @OptionalField(key: "distance") //0 , 1, 2
        var distance: Int?

        @OptionalField(key: "openID")
        var openId: String?

        @OptionalField(key: "restaruant")
        var restaruant: String?

        @OptionalField(key: "selfInfo")
        var selfInfo: String?

        @OptionalField(key: "haveCookie")
        var haveCookie: Bool?

        @OptionalField(key: "myCookie")
        var myCookie: Cookie?

        @OptionalField(key: "pickedCookies")
        var pickedCookies: [Cookie]?

        @OptionalField(key: "lastPickedTime")
        var lastPicked: Date?
            
        init(
          id: UUID? = nil,
          email: String,
          appleUserIdentifier: String
        ) {
          self.id = id
          self.email = email
          self.appleUserIdentifier = appleUserIdentifier
        }

    }
    extension User: Authenticatable {
      struct Public: Content {
        let id: UUID
        let email: String

        init(user: User) throws {
          self.id = try user.requireID()
          self.email = user.email
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
    //  static func assertUniqueEmail(_ email: String, req: Request) async throws {
    //      guard let user = try await findByEmail(email, req: req) else {
    //          throw UserError.emailTaken
    //    }
    ////return true
    //  }

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

