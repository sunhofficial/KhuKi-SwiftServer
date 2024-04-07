//
//  File.swift
//  
//
//  Created by 235 on 4/2/24.
//

import Foundation
import Vapor
extension Environment {
    // service bundle identifier
    static var siwaId = Environment.get("SIWA_ID")!
    // registered redirect url
    static let siwaRedirectUrl = Environment.get("SIWA_REDIRECT_URL")!
    // team identifier
    static var siwaTeamId = Environment.get("SIWA_TEAM_ID")!
    // key identifier
    static var siwaJWKId = Environment.get("SIWA_JWK_ID")!
    // contents of the downloaded key file
    static var siwaKey = Environment.get("SIWA_KEY")!
}
