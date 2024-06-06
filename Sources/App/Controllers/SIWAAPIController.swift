//
//  File.swift
//
//
//  Created by 235 on 4/3/24.
//
import Fluent
import JWT
import Vapor

struct SIWAAPIController {

    struct SIWARequestBody: Content {
        let appleIdentityToken: String
    }

    func authHandler(req: Request) async throws -> GeneralResponse<UserResponse> {

            let userBody = try req.content.decode(SIWARequestBody.self)
            print(userBody)
            let appleIdentityToken = try await req.jwt.apple.verify(
                userBody.appleIdentityToken,
                applicationIdentifier: ProjectConfig.SIWA.applicationIdentifier
            )
            if let user = try await User.findByAppleIdentifier(appleIdentityToken.subject.value, req: req) {
                return try await SIWAAPIController.signIn(
                    appleIdentityToken: appleIdentityToken,
                    req: req
                )
            } else {
                return try await SIWAAPIController.signUp(
                    appleIdentityToken: appleIdentityToken,
                    req: req
                )
            }


    }
    static func signUp(
        appleIdentityToken: AppleIdentityToken,
        req: Request
    ) async throws -> GeneralResponse<UserResponse> {
        guard let email = appleIdentityToken.email else {
            throw UserError.siwaEmailMissing
        }
        let user = User(
            email: email,
            appleUserIdentifier: appleIdentityToken.subject.value
        )

        try await user.save(on: req.db)
        guard let accessToken = try? user.createAccessToken(req: req) else {
            throw Abort(.internalServerError)
        }

        try await accessToken.save(on: req.db)
        return try GeneralResponse(status: 200, message: "회원가입성공", data: UserResponse(accessToken: accessToken, user: user) )
    }

    static func signIn(
        appleIdentityToken: AppleIdentityToken,
        req: Request
    ) async throws -> GeneralResponse< UserResponse> {
        guard let user = try await User.findByAppleIdentifier(appleIdentityToken.subject.value, req: req) else {
            throw UserError.siwaInvalidState
        }

        var accessToken: Token
        let existingToken = try await Token.query(on: req.db)
            .filter(\.$user.$id == user.id! ) // User 모델과 연관된 키를 사용하여 필터
            .first()
        let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        if let existingToken = existingToken, let expiresAt = existingToken.expiresAt, expiresAt >= sevenDaysLater {
               // If the token exists and is valid for more than 7 days from now, reuse it.
               accessToken = existingToken
           } else {
               // Otherwise, create a new access token and save it.
               accessToken = try user.createAccessToken(req: req)
               try await accessToken.save(on: req.db)
           }
        let response = try UserResponse(accessToken: accessToken, user: user)
        debugPrint(user)
        if user.age == nil {
            return GeneralResponse(status: 200, message: "첫번째프로필", data: response)
        } else if user.selfInfo == nil {
            return GeneralResponse(status: 200, message: "두번째프로필", data: response)
        }
        else {
//            let haveMyCookie = try await Cookie.query(on: req.db)
//                .filter(\.$user.$id == user.id!)
//                .count() > 0
//            if haveMyCookie {
                return GeneralResponse(status: 200, message: "로그인성공", data: response)
//            }
//            else {
//                return GeneralResponse(status: 200, message: "쿠키생성", data: response)
//            }
        }
    }

}

// MARK: - RouteCollection
extension SIWAAPIController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post(use: authHandler)
    }
}
