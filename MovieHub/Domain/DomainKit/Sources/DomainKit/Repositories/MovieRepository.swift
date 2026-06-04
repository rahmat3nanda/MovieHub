import Foundation

public protocol MovieRepository {
    func getDetail(request: MovieRequest) async throws -> Movie
    func getReviews(request: MovieRequest) async throws -> MovieReviewList
}
