import Foundation

public protocol MovieListRepository {
    func getNowPlaying(request: MovieListRequest) async throws -> MovieList
    func getPopular(request: MovieListRequest) async throws -> MovieList
    func getTopRated(with request: MovieListRequest) async throws -> MovieList
    func getUpcoming(with request: MovieListRequest) async throws -> MovieList
}
