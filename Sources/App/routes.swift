import Vapor

func routes(_ app: Application) throws {
    let unprotectedAPI = app.grouped("api")
    try unprotectedAPI.grouped("auth", "siwa").register(collection: SIWAAPIController())
    let tokenProtectedAPI = unprotectedAPI.grouped(Token.authenticator())
    try tokenProtectedAPI.grouped("users").register(collection: UserAPIController())

    let unprotectedWeb = app.grouped("web")
    try unprotectedWeb.grouped("auth", "siwa").register(collection: SIWAViewController())
//   try app.register(collection: MoviesController())
//    app.middleware.use(LogMiddleware())
//    // /members
//    app.grouped(AuthenticationMiddleware()).group("members") { route in
//        route.get { req async -> String in
//            return "MEMBERS INDEX"
//        }
//        route.get("hello") { req async -> String in
//            return "MEMBERS HELLO"
//        }
//    }
//app.get { req async in
//        "It works!"
//    }
//
//    app.get("hello") { req async -> String in
//        "Hello, world!"
//    }
//
//
//    // dynamic하게 해준다. 마찬가지로 뒤에 더 붙이고 싶으면 콤마 쓰고 :anything쓰면댐
//    app.get("movies", ":menu") { req async throws -> String in
////        let name = req.parameters.get("name") //이렇게 하면 옵셔널 타입으로 나옴
//        guard let name = req.parameters.get("menu") else {
//            throw Abort(.badRequest)
//        }
//        return "Alllll name of genre: \(String(describing: name))"
//    }
//    app.get("movies","pages",":pageId") { req async throws -> String in
//        guard let pageId = req.parameters.get("pageId", as: Int.self) else {
//            throw Abort(.badRequest)
//        }
//        return "\(pageId)"
//    }
//
//    app.get("movies") { req async in
//        [Movie(title: "봄낭ㄹ은 간다", year: 1999) , Movie(title: "good day to. ie", year: 2010)]
//    }
//
//    app.post("movies") { req async throws in
//        let movie = try req.content.decode(Movie.self)
//        return movie
//    }
//
//
//    // schools
//    // /schools/123
//    let schools = app.grouped("schools")
//    schools.get { req async throws -> String in
//        return "schools"
//    }
//    schools.get(":schoolID") { req async throws -> String in
//        guard let schoolId = req.parameters.get("schoolID") else {
//            throw Abort(.badRequest)
//        }
//        return schoolId
//    }

     
}

