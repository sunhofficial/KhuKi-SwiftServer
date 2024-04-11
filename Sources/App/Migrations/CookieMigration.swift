
import Fluent

struct CookieMigration: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.schema)
            .field("id", .uuid, .identifier(auto: true))
            .field("info", .string, .required)
            .field("type",.int,.required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Cookie.schema).delete()
    }
}
