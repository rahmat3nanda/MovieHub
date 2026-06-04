import DIContainer
import Foundation
import DomainKit
import Persistence

public struct MovieStorageKey: KeyStorage {
    public let rawValue: String
    
    public static func detail(id: Int) -> MovieStorageKey {
        return MovieStorageKey(rawValue: "movie_detail_\(id)")
    }
    
    public static func reviews(id: Int) -> MovieStorageKey {
        return MovieStorageKey(rawValue: "movie_reviews_\(id)")
    }
}

public final class DefaultMovieLocalDataSource: MovieLocalDataSource {
    @Inject
    private var storage: Storage

    public init() {}

    public func getDetail(request: MovieRequest) async throws -> MovieResponseDTO {
        guard let data = try storage.get(MovieResponseDTO.self, forKey: MovieStorageKey.detail(id: request.id)) else {
            struct CacheMissError: Error {}
            throw CacheMissError()
        }
        return data
    }
    
    public func getReviews(request: MovieRequest) async throws -> MovieReviewListResponseDTO {
        guard let data = try storage.get(MovieReviewListResponseDTO.self, forKey: MovieStorageKey.reviews(id: request.id)) else {
            struct CacheMissError: Error {}
            throw CacheMissError()
        }
        return data
    }
    
    public func saveDetail(_ movie: MovieResponseDTO) async throws {
        try storage.set(movie, forKey: MovieStorageKey.detail(id: movie.id))
    }
    
    public func saveReviews(_ reviews: MovieReviewListResponseDTO, forMovieId movieId: Int) async throws {
        try storage.set(reviews, forKey: MovieStorageKey.reviews(id: movieId))
    }
}
