import Foundation

public final class GetNowPlayingMoviesUseCase {
    private let repository: MovieListRepository
    
    public init(repository: MovieListRepository) {
        self.repository = repository
    }
    
    public func execute(request: MovieListRequest) async throws -> MovieList {
        try await repository.getNowPlaying(request: request)
    }
}
