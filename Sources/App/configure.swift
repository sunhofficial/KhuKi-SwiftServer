import Vapor
import Fluent
import FluentMongoDriver
import Leaf


// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes

    app.middleware.use(SessionsMiddleware(session: app.sessions.driver))
    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease
    try app.databases.use(.mongo(connectionString: "mongodb+srv://sunh803:passwordTest123@khukicluster.liwexmo.mongodb.net/userDB?retryWrites=true&w=majority&appName=KhuKiCluster"), as: .mongo)
    //register controllers
    app.migrations.add(UserMigration())
    app.migrations.add(TokenMigration())
    app.migrations.add(CookieMigration())
    try app.autoMigrate().wait()
    try routes(app)
}
