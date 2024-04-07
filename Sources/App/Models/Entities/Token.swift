
import Vapor
import Fluent

final class Token: Model {
  static let schema = "tokens"

  @ID(key: "id")
  var id: UUID?

  @Parent(key: "userID")
  var user: User

  @Field(key: "value")
  var value: String

  @Field(key: "expiresAt")
  var expiresAt: Date?

  @Timestamp(key: "createdAt", on: .create)
  var createdAt: Date?

  init() {}

  init(
    id: UUID? = nil,
    userID: User.IDValue,
    token: String,
    expiresAt: Date?
  ) {
    self.id = id
    self.$user.id = userID
    self.value = token
    self.expiresAt = expiresAt
  }
}

// MARK: - ModelTokenAuthenticatable
extension Token: ModelTokenAuthenticatable {
  static let valueKey = \Token.$value
  static let userKey = \Token.$user

  var isValid: Bool {
    guard let expiryDate = expiresAt else {
      return true
    }

    return expiryDate > Date()
  }
}
