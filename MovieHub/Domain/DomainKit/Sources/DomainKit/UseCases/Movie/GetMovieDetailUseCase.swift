import Foundation

public final class GetMovieDetailUseCase {
    private let repository: MovieRepository
    
    public init(repository: MovieRepository) {
        self.repository = repository
    }
    
    public func execute(request: MovieRequest) async throws -> Movie {
        try await repository.getDetail(request: request)
    }
}
