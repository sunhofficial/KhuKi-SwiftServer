
import Fluent

struct UserMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema)
            .id()
            .field("email", .string, .required)
            .field("firstName", .string)
            .field("lastName", .string)
            .field("appleUserIdentifier", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema).delete()
    }
}
