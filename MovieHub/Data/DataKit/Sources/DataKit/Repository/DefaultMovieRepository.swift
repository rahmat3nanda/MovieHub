import Foundation
import DomainKit

public final class DefaultMovieRepository: MovieRepository {
    private let dataSource: MovieDataSource

    public init(dataSource: MovieDataSource) {
        self.dataSource = dataSource
    }
    
    public func getDetail(request: MovieRequest) async throws -> Movie {
        let dto = try await dataSource.getDetail(request: request)
        return dto.toDomain()
    }
    
    public func getReviews(request: MovieRequest) async throws -> MovieReviewList {
        let dto = try await dataSource.getReviews(request: request)
        return dto.toDomain()
    }
}
