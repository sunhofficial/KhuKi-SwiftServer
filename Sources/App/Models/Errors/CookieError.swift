//
//  File.swift
//  
//
//  Created by 235 on 5/9/24.
//

import Foundation
import Vapor
enum CookieError {
    case noMyCookie
    case someOnePick
    
}

extension CookieError: AbortError {
    var status: HTTPResponseStatus {
        switch self {
        case .noMyCookie:
                .badRequest
        case .someOnePick:
                .conflict
        }
    }
    var reason: String {
        switch self {
        case .noMyCookie:
            "내 쿠키를 먼저 만들어주세요"
        case .someOnePick:
            "동시성 문제 발생"
        }
    }


}
