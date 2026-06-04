import DIContainer
import Foundation
import NetworkManager
import DomainKit

public final class DefaultMovieRemoteDataSource: MovieDataSource {
    @Inject
    private var networkService: NetworkService

    public init() {}

    public func getDetail(request: MovieRequest) async throws -> MovieResponseDTO {
        try await networkService.request(MovieEndpoint.detail(request))
    }
    
    public func getReviews(request: MovieRequest) async throws -> MovieReviewListResponseDTO {
        try await networkService.request(MovieEndpoint.reviews(request))
    }
}
