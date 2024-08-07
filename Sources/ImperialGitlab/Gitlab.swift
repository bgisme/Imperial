@_exported import ImperialCore
import Vapor

public class Gitlab: FederatedService {
    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter

    @discardableResult
    public required init(
        grouped: [PathComponent],
        routes: RoutesBuilder,
        authenticate: String,
        authenticateCallback: ((Request) throws -> (EventLoopFuture<Void>))?,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    ) throws {
        self.router = try GitlabRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens

        self.router.scope = scope
        try self.router.configureRoutes(grouped: grouped, withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)

        OAuthService.register(.gitlab)
    }
}

