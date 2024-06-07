//
//  File.swift
//  
//
//  Created by 235 on 4/4/24.
//

import Foundation

import Vapor

enum UserError {
  case emailTaken
  case siwaEmailMissing
  case siwaInvalidState
}
extension UserError: AbortError {
  var description: String { reason }

  var status: HTTPResponseStatus {
    switch self {
    case .emailTaken: return .conflict
    case .siwaEmailMissing: return .badRequest
    case .siwaInvalidState: return .badRequest
    }
  }

  var reason: String {
    switch self {
    case .emailTaken: return "이 이메일 이미 저장되어있는데요..?"
    case .siwaEmailMissing: return "올바르지 않는 형식입니다. 다시보내주세요."
    case .siwaInvalidState: return "Invalid state"
    }
  }
}
