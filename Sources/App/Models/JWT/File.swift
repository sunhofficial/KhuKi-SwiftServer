////
////  File.swift
////  
////
////  Created by 235 on 3/28/24.
////
//
//import Foundation
//import Vapor
//import JWT
//
//struct Payload: JWTPayload, Authenticatable {
//    // User-releated stuff
//    var userID: UUID
//    var fullName: String
//    var openId: String
//    var isAdmin: Bool
//
//    // JWT stuff
//    var exp: ExpirationClaim
//    // 액세스토큰
//    var subject: SubjectClaim
//
//    func verify(using signer: JWTSigner) throws {
//        try self.exp.verifyNotExpired()
//    }
//
//    init(with user: User) throws {
//        self.userID = try user.requireID()
//        self.fullName = user.fullName
//        self.openId = user.openId
//        self.isAdmin = user.isAdmin
//        self.exp = ExpirationClaim(value: Date().addingTimeInterval(Constants.ACCESS_TOKEN_LIFETIME))
//    }
//}
//
//extension User {
//    convenience init(from payload: Payload) {
//        self.init(id: payload.userID, fullName: payload.fullName, email: payload.email, passwordHash: "", isAdmin: payload.isAdmin)
//    }
//}
