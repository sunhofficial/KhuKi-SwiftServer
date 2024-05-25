
import JWT
import Leaf
import Vapor

final class SIWAViewController {

  struct SignInViewContext: Encodable {
    let clientID: String
    let scope: String
    let redirectURL: String
    let state: String
  }

    func renderSignIn(req: Request) async throws -> View {
      let state = [UInt8].random(count: 32).base64
      req.session.data["state"] = state

      return try await req.view.render(
        "Auth/siwa",
        SignInViewContext(
          clientID: ProjectConfig.SIWA.servicesIdentifier,
          scope: "name email",
          redirectURL: ProjectConfig.SIWA.redirectURL,
          state: state
        )
      )
    }

    func callback(req: Request) async throws -> GeneralResponse<UserResponse> {
      let auth = try req.content.decode(AppleAuthorizationResponse.self)
      guard
        let sessionState = req.session.data["state"],
        !sessionState.isEmpty,
        sessionState == auth.state else {
          throw UserError.siwaInvalidState
      }

      let appleIdentityToken = try await req.jwt.apple.verify(
        auth.idToken,
        applicationIdentifier: ProjectConfig.SIWA.servicesIdentifier
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

}

// MARK: - RouteCollection
extension SIWAViewController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.get("sign-in", use: renderSignIn)
    routes.post("callback", use: callback)
  }
}
