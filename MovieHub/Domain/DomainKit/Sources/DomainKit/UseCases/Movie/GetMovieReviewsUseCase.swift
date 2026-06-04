import Foundation

public final class GetMovieReviewsUseCase {
    private let repository: MovieRepository
    
    public init(repository: MovieRepository) {
        self.repository = repository
    }
    
    public func execute(request: MovieRequest) async throws -> MovieReviewList {
        try await repository.getReviews(request: request)
    }
}
