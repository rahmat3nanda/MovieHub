import Foundation

public final class GetTopRatedMoviesUseCase {
    private let repository: MovieListRepository
    
    public init(repository: MovieListRepository) {
        self.repository = repository
    }
    
    public func execute(request: MovieListRequest) async throws -> MovieList {
        try await repository.getTopRated(with: request)
    }
}
