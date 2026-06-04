import DIContainer
import Foundation
import NetworkManager
import DomainKit

public final class DefaultMovieListRemoteDataSource: MovieListDataSource {
    @Inject
    private var networkService: NetworkService

    public init() {}

    public func getPopular(request: MovieListRequest) async throws -> MovieListResponseDTO {
        try await networkService.request(MovieListEndpoint.popular(request))
    }
    
    public func getNowPlaying(request: MovieListRequest) async throws -> MovieListResponseDTO {
        try await networkService.request(MovieListEndpoint.nowPlaying(request))
    }
    
    public func getTopRated(request: MovieListRequest) async throws -> MovieListResponseDTO {
        try await networkService.request(MovieListEndpoint.topRated(request))
    }
    
    public func getUpcoming(request: MovieListRequest) async throws -> MovieListResponseDTO {
        try await networkService.request(MovieListEndpoint.upcoming(request))
    }
}
