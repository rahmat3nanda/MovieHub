import DomainKit
import NetworkManager

public enum MovieEndpoint: Endpoint {
    case detail(MovieRequest)
    case reviews(MovieRequest)

    public var path: String {
        switch self {
        case let .detail(request): "3/movie/\(request.id)"
        case let .reviews(request): "3/movie/\(request.id)/reviews"
        }
    }

    public var method: NetworkManager.HTTPMethod {
        switch self {
        default: .get
        }
    }
}
