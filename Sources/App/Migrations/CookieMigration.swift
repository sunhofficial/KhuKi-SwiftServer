
import Fluent

struct CookieMigration: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Token.schema)
            .field("id", .uuid, .identifier(auto: true))
            .field("userID", .uuid, .references("users", "id"))
            .field("info", .string, .required)
            .field("type",.int,.required)
            .field("gender", .string,.required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Cookie.schema).delete()
    }
}
