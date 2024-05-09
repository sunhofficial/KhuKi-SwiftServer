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
    case alreadyPicked
}

extension CookieError: AbortError {
    var status: HTTPResponseStatus {
        switch self {
        case .noMyCookie:
                .badRequest
        case .someOnePick:
                .conflict
        case .alreadyPicked:
                .forbidden
        }
    }
    var reason: String {
        switch self {
        case .noMyCookie:
            "내 쿠키를 먼저 만들어주세요"
        case .someOnePick:
            "동시성 문제 발생"
        case .alreadyPicked:
            "새로운 쿠키를 뽑기까지 24시간이 지나야합니다."
        }
    }


}
