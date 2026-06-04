import Foundation
import DomainKit

public final class DefaultMovieListRepository: MovieListRepository {
    private let dataSource: MovieListDataSource

    public init(dataSource: MovieListDataSource) {
        self.dataSource = dataSource
    }
    
    public func getPopular(request: MovieListRequest) async throws -> MovieList {
        let dto = try await dataSource.getPopular(request: request)
        return dto.toDomain()
    }
    
    public func getNowPlaying(request: MovieListRequest) async throws -> MovieList {
        let dto = try await dataSource.getNowPlaying(request: request)
        return dto.toDomain()
    }
    
    public func getTopRated(with request: MovieListRequest) async throws -> MovieList {
        let dto = try await dataSource.getTopRated(request: request)
        return dto.toDomain()
    }
    
    public func getUpcoming(with request: MovieListRequest) async throws -> MovieList {
        let dto = try await dataSource.getUpcoming(request: request)
        return dto.toDomain()
    }
}
