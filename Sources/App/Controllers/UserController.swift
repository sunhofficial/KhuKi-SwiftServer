////
////  File.swift
////  
////
////  Created by 235 on 3/26/24.
////
//
//import Foundation
//import Vapor
//import Fluent
//import FluentMongoDriver
//class UserController: RouteCollection {
//    func boot(routes: RoutesBuilder) throws {
//        let api = routes.grouped("api")
//        // post 요청 /api/users
//        api.post("users", use: create)
//
//        // get요청 /api/users
//        api.get("users", use: getAll)
//
//        // get by id
//        api.get("users", ":userId", use: getByID)
//
//        //delete
//        api.delete("users", ":userId", use: deleteByID)
//
//        //update
//        api.put("users", ":userId", use: updateUser)
//    }
//    func create(req: Request) async throws -> User {
//        let user = try req.content.decode(User.self)
//        try await user.save(on: req.db)
//        return user
//    }
//
//    func getAll(req: Request) async throws -> [User] {
//        return try await User.query(on: req.db).all()
//    }
//
//    func getByID(req: Request) async throws -> User {
//        guard let userID = req.parameters.get("userId", as: UUID.self) else {
//            throw Abort(.notFound)
//        }
//        guard let user = try await User.find(userID, on: req.db) else {
//            throw Abort(.notFound, reason: "UserId \(userID) was not found")
//        }
//        return user
//    }
//    func deleteByID(req: Request) async throws -> User {
//        guard let userID = req.parameters.get("userId", as: UUID.self) else {
//            throw Abort(.notFound)
//        }
//        guard let user = try await User.find(userID, on: req.db) else {
//            throw Abort(.notFound, reason: "UserId \(userID) was not found")
//        }
//        try await user.delete(on: req.db)
//        return user
//    }
//    func updateUser(req: Request) async throws -> User {
//        guard let userID = req.parameters.get("userId", as: UUID.self) else {
//            throw Abort(.notFound)
//        }
//        guard let user = try await User.find(userID, on: req.db) else {
//            throw Abort(.notFound, reason: "UserId \(userID) was not found")
//        }
//        let updateUser = try req.content.decode(User.self)
//        user.openId = updateUser.openId
//        user.restraunt = updateUser.restraunt
//        try await user.update(on: req.db)
//        return user
//    }
//
//}
