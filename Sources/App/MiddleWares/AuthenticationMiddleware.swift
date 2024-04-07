//
//  File.swift
//  
//
//  Created by 235 on 3/20/24.
//

import Foundation
import Vapor

struct AuthenticationMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        // Headers: Authorization: Bearer EDFDFJOIJ
        guard let authorization = request.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        print(authorization.token)
        return try await next.respond(to: request)
    }
}
