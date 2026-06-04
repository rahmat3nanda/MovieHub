import Foundation
import DomainKit

public final class MovieDataSourceDecorator: MovieDataSource {
    private let remote: MovieDataSource
    private let local: MovieLocalDataSource

    public init(remote: MovieDataSource, local: MovieLocalDataSource) {
        self.remote = remote
        self.local = local
    }

    public func getDetail(request: MovieRequest) async throws -> MovieResponseDTO {
        do {
            let remoteMovie = try await remote.getDetail(request: request)
            try? await local.saveDetail(remoteMovie)
            return remoteMovie
        } catch {
            return try await local.getDetail(request: request)
        }
    }
    
    public func getReviews(request: MovieRequest) async throws -> MovieReviewListResponseDTO {
        do {
            let remoteReviews = try await remote.getReviews(request: request)
            try? await local.saveReviews(remoteReviews, forMovieId: request.id)
            return remoteReviews
        } catch {
            return try await local.getReviews(request: request)
        }
    }
}
