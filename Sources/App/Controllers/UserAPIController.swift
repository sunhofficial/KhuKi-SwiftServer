import Fluent
import JWT
import Vapor

struct UserAPIController {
    //  func getMeHandler(req: Request) throws -> UserResponse {
    //    let user = try req.auth.require(User.self)
    //    return try .init(user: user)
    //  }
    func updatefirstProfile(req: Request) async throws -> GeneralResponse<VoidContent> {
        let user = try req.auth.require(User.self)
        do {
            let updateRequest = try req.content.decode(ProfileUpdateRequestFirst.self)
            user.gender = updateRequest.gender
            user.age = updateRequest.age
            user.distance = updateRequest.distance
            try await user.save(on: req.db)
            return GeneralResponse(status: 200, message: "update성공")
        } catch DecodingError.typeMismatch(_, let context) {
            // 데이터 형식이 예상과 일치하지 않는 경우
            return GeneralResponse(status: 400, message: "데이터 형식이 일치하지 않음: \(context.debugDescription)")
        } catch let databaseError as DatabaseError {
            // 데이터베이스에서 발생한 에러 처리
            return GeneralResponse(status: 500, message: "데이터베이스 에러: \(databaseError)")
        } catch {
            // 기타 예외 처리
            return GeneralResponse(status: 404, message: "알 수 없는 에러")
        }
    }
    func updateSecondProfile(req: Request) async throws -> GeneralResponse<VoidContent> {
        let user = try req.auth.require(User.self)
        do {
            let updateRequest = try req.content.decode(ProfileUpdateRequestSecond.self)
            user.openId = updateRequest.openId
            user.restaruant = updateRequest.restaruant
            user.selfInfo = updateRequest.selfInfo
            try await user.save(on: req.db)
            return GeneralResponse(status: 200, message: "update성공")
        } catch DecodingError.typeMismatch(_, let context) {
            // 데이터 형식이 예상과 일치하지 않는 경우
            return GeneralResponse(status: 400, message: "데이터 형식이 일치하지 않음: \(context.debugDescription)")
        } catch let databaseError as DatabaseError {
            // 데이터베이스에서 발생한 에러 처리
            return GeneralResponse(status: 500, message: "DB Error: \(databaseError)")
        } catch {
            // 기타 예외 처리
            return GeneralResponse(status: 404, message: "알 수 없는 에러")
        }
    }
    func deleteUser(req: Request) async throws -> GeneralResponse<VoidContent> {
        let user = try req.auth.require(User.self)
        do {
            try await user.delete(on: req.db)
        }
        catch let databaseError as DatabaseError {
            return GeneralResponse(status: 500, message: "DB Error")
        }
        return GeneralResponse(status: 200, message: "삭제성공")
    }
    func postCookie(req: Request) async throws -> GeneralResponse<VoidContent> {
        do {
            // 1. 사용자 인증 오류 처리
            let user = try req.auth.require(User.self)

            // 2. 요청 바디 디코딩 오류 처리
            let postRequest = try req.content.decode(PostCookieRequest.self)


            let cookie = Cookie(id: try user.requireID(), info: postRequest.info, type: postRequest.type, gender: postRequest.gender, user: user)
            // 3. 데이터베이스 저장 오류 처리
//            user.myCookie = cookie
//            try await user.save(on: req.db)
            try await cookie.save(on: req.db)

            return GeneralResponse(status: 200, message: "쿠키생성성공")
        } catch DecodingError.typeMismatch(_, let context) {
            // 데이터 형식이 예상과 일치하지 않는 경우
            return GeneralResponse(status: 401, message: "데이터 형식이 일치하지 않음: \(context.debugDescription)")
        } catch let databaseError as DatabaseError {
            // 데이터베이스에서 발생한 에러 처리
            return GeneralResponse(status: 500, message: "데이터베이스 에러: \(databaseError)")
        } catch {
            // 기타 예외 처리
            return GeneralResponse(status: 404, message: "알 수 없는 에러")
        }
    }
    func putCookie(req: Request) async throws -> GeneralResponse<VoidContent> {
        do {
            let user = try req.auth.require(User.self)
            let putRequest = try req.content.decode(UpdateCookie.self)

            // 사용자의 쿠키 찾기
            guard let myCookie = try await Cookie.find(user.id, on: req.db) else {
                throw Abort(.notFound, reason: "해당하는 쿠키를 찾을 수 없음")
            }

            // 쿠키 업데이트
            myCookie.info = putRequest.info
            myCookie.type = putRequest.type
            user.myCookie = myCookie

            // 사용자 및 쿠키 업데이트 저장
            try await user.update(on: req.db)
            try await myCookie.update(on: req.db)

            return GeneralResponse(status: 200, message: "쿠키 업데이트 성공")
        } catch let abortError as AbortError {
            // 기타 에러 처리
            return GeneralResponse(status: Int(abortError.status.code), message: abortError.reason)
        } catch {
            // 기타 예외 처리
            return GeneralResponse(status: 404, message: "알 수 없는 에러")
        }
    }
    func getPickedCookies(req: Request) async throws -> GeneralResponse<[Cookie]> {
        let user = try req.auth.require(User.self)
        if let pickedCookies = user.pickedCookies {
            return GeneralResponse(status: 200, message: "쿠키있음",data: pickedCookies)
        } else {
            return GeneralResponse(status: 402, message: "아직 쿠키가 없어요")
        }
    }
}

// MARK: - RouteCollection
extension UserAPIController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.put("profile","first", use: updatefirstProfile)
        routes.put("profile","second", use: updateSecondProfile)
        routes.delete("delete", use: deleteUser)
        routes.post("cookie", use: postCookie)
        routes.put("cookie", use: putCookie)
        //      routes.get("cookie","picked")

    }
}
