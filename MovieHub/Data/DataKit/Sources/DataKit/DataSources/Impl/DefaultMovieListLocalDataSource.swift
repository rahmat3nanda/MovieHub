import DIContainer
import Foundation
import DomainKit
import Persistence

public enum MovieListStorageKey: String, KeyStorage {
    case popular = "movie_list_popular"
    case nowPlaying = "movie_list_now_playing"
    case topRated = "movie_list_top_rated"
    case upcoming = "movie_list_upcoming"
}

public final class DefaultMovieListLocalDataSource: MovieListLocalDataSource {
    @Inject
    private var storage: Storage

    public init() {}

    public func getPopular(request: MovieListRequest) async throws -> MovieListResponseDTO {
        guard let data = try storage.get(MovieListResponseDTO.self, forKey: MovieListStorageKey.popular) else {
            return MovieListResponseDTO(page: request.page, results: [], totalPages: 0, totalResults: 0)
        }
        return data
    }
    
    public func getNowPlaying(request: MovieListRequest) async throws -> MovieListResponseDTO {
        guard let data = try storage.get(MovieListResponseDTO.self, forKey: MovieListStorageKey.nowPlaying) else {
            return MovieListResponseDTO(page: request.page, results: [], totalPages: 0, totalResults: 0)
        }
        return data
    }
    
    public func getTopRated(request: MovieListRequest) async throws -> MovieListResponseDTO {
        guard let data = try storage.get(MovieListResponseDTO.self, forKey: MovieListStorageKey.topRated) else {
            return MovieListResponseDTO(page: request.page, results: [], totalPages: 0, totalResults: 0)
        }
        return data
    }

    public func getUpcoming(request: MovieListRequest) async throws -> MovieListResponseDTO {
        guard let data = try storage.get(MovieListResponseDTO.self, forKey: MovieListStorageKey.upcoming) else {
            return MovieListResponseDTO(page: request.page, results: [], totalPages: 0, totalResults: 0)
        }
        return data
    }
    
    public func savePopular(_ movies: MovieListResponseDTO) async throws {
        try storage.set(movies, forKey: MovieListStorageKey.popular)
    }
    
    public func saveNowPlaying(_ movies: MovieListResponseDTO) async throws {
        try storage.set(movies, forKey: MovieListStorageKey.nowPlaying)
    }
    
    public func saveTopRated(_ movies: MovieListResponseDTO) async throws {
        try storage.set(movies, forKey: MovieListStorageKey.topRated)
    }
    
    public func saveUpcoming(_ movies: MovieListResponseDTO) async throws {
        try storage.set(movies, forKey: MovieListStorageKey.upcoming)
    }
}
