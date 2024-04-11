//
//  File.swift
//  
//
//  Created by 235 on 3/20/24.
//

import Foundation
import Vapor

struct LogMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        print("Log MiddleWare")
        return try await next.respond(to: request) //이걸써줘야 다음 액션이 이루어짐. 
        
    }
}
