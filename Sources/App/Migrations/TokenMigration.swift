
import Fluent

struct TokenMigration: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.schema)
            .field("id", .uuid, .identifier(auto: true))
            .field("userID", .uuid, .references("users", "id"))
            .field("value", .string, .required)
            .unique(on: "value")
            .field("createdAt", .datetime, .required)
            .field("expiresAt", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.schema).delete()
    }
}
