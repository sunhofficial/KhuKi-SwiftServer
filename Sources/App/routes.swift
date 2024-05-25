import Vapor

func routes(_ app: Application) throws {
    let unprotectedAPI = app.grouped("api")
    try unprotectedAPI.grouped("auth", "siwa").register(collection: SIWAAPIController())
    let tokenProtectedAPI = unprotectedAPI.grouped(Token.authenticator()) //이게 여기를 통하는 거는 모두 authenticated user가 있어야한다는뜻.
    try tokenProtectedAPI.grouped("user").register(collection: UserAPIController())
    try tokenProtectedAPI.grouped("cookies").register(collection: CookieAPIController())
}

