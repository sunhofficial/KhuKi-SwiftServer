import Vapor
import Fluent
import FluentMongoDriver
import Leaf
import Ferno


// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    let fernoConfiguration = FernoDefaultConfiguration(
        basePath: "database-url",
        email: "service-account-email",
        privateKey: "private-key"
    )
    app.ferno.use(.default(fernoConfiguration))
    app.middleware.use(SessionsMiddleware(session: app.sessions.driver))
    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease
    try app.databases.use(.mongo(connectionString: "mongodb+srv://sunh803:passwordTest123@khukicluster.liwexmo.mongodb.net/userDB?retryWrites=true&w=majority&appName=KhuKiCluster"), as: .mongo)
    //register controllers
    app.migrations.add(UserMigration())
    app.migrations.add(TokenMigration())
    try app.autoMigrate().wait()
    try routes(app)
}
