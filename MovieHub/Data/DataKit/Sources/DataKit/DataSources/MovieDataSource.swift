import Foundation
import DomainKit

public protocol MovieDataSource {
    func getDetail(request: MovieRequest) async throws -> MovieResponseDTO
    func getReviews(request: MovieRequest) async throws -> MovieReviewListResponseDTO
}

public protocol MovieLocalDataSource: MovieDataSource {
    func saveDetail(_ movie: MovieResponseDTO) async throws
    func saveReviews(_ reviews: MovieReviewListResponseDTO, forMovieId movieId: Int) async throws
}
