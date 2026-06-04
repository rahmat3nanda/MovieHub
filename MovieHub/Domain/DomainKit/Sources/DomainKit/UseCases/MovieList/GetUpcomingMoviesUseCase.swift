import Foundation

public final class GetUpcomingMoviesUseCase {
    private let repository: MovieListRepository
    
    public init(repository: MovieListRepository) {
        self.repository = repository
    }
    
    public func execute(request: MovieListRequest) async throws -> MovieList {
        try await repository.getUpcoming(with: request)
    }
}
