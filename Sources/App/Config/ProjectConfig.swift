//
//  File.swift
//  
//
//  Created by 235 on 4/3/24.
//
import Vapor

struct ProjectConfig {
  struct AccessToken {
    static let expirationTime: TimeInterval = 30 * 24 * 60 * 60 // 30 days
  }

  struct SIWA {
    static let applicationIdentifier = Environment.get("SIWA_APPLICATION_IDENTIFIER")! //e.g. com.raywenderlich.siwa-vapor
    static let servicesIdentifier = Environment.get("SIWA_SERVICES_IDENTIFIER")! //e.g. com.raywenderlich.siwa-vapor.services
    static let redirectURL = Environment.get("SIWA_REDIRECT_URL")! // e.g. https://foobar.ngrok.io/web/auth/siwa/callback
  }
}
