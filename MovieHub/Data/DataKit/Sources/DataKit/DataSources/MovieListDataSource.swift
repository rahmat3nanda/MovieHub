import Foundation
import DomainKit

public protocol MovieListDataSource {
    func getPopular(request: MovieListRequest) async throws -> MovieListResponseDTO
    func getNowPlaying(request: MovieListRequest) async throws -> MovieListResponseDTO
    func getTopRated(request: MovieListRequest) async throws -> MovieListResponseDTO
    func getUpcoming(request: MovieListRequest) async throws -> MovieListResponseDTO
}

public protocol MovieListLocalDataSource: MovieListDataSource {
    func savePopular(_ movies: MovieListResponseDTO) async throws
    func saveNowPlaying(_ movies: MovieListResponseDTO) async throws
    func saveTopRated(_ movies: MovieListResponseDTO) async throws
    func saveUpcoming(_ movies: MovieListResponseDTO) async throws
}
