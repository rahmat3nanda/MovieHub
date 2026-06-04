import XCTest
import DomainKit
@testable import DataKit

// swiftlint:disable:this function_body_length line_length
final class OfflineFirstMovieDataSourceTests: XCTestCase {
    
    private final class MockMovieDataSource: MovieListDataSource {
        var result: Result<MovieListResponseDTO, Error> = .success(MovieListResponseDTO(dates: nil, page: 1, results: [], totalPages: 0, totalResults: 0))
        var callCount = 0
        
        func getPopular(request: MovieListRequest) async throws -> MovieListResponseDTO {
            callCount += 1
            return try result.get()
        }
        
        func getNowPlaying(request: MovieListRequest) async throws -> MovieListResponseDTO {
            callCount += 1
            return try result.get()
        }
        
        func getTopRated(request: MovieListRequest) async throws -> MovieListResponseDTO {
            callCount += 1
            return try result.get()
        }
        
        func getUpcoming(request: MovieListRequest) async throws -> MovieListResponseDTO {
            callCount += 1
            return try result.get()
        }
    }
    
    private final class MockMovieLocalDataSource: MovieListLocalDataSource {
        var popularMovies: MovieListResponseDTO = MovieListResponseDTO(dates: nil, page: 1, results: [], totalPages: 0, totalResults: 0)
        var nowPlayingMovies: MovieListResponseDTO = MovieListResponseDTO(dates: nil, page: 1, results: [], totalPages: 0, totalResults: 0)
        var fetchCallCount = 0
        var savePopularCallCount = 0
        var saveNowPlayingCallCount = 0
        
        func getPopular(request: MovieListRequest) async throws -> MovieListResponseDTO {
            fetchCallCount += 1
            return popularMovies
        }
        
        func getNowPlaying(request: MovieListRequest) async throws -> MovieListResponseDTO {
            fetchCallCount += 1
            return nowPlayingMovies
        }
        
        func getTopRated(request: MovieListRequest) async throws -> MovieListResponseDTO {
            fetchCallCount += 1
            return MovieListResponseDTO(dates: nil, page: 1, results: [], totalPages: 0, totalResults: 0)
        }
        
        func getUpcoming(request: MovieListRequest) async throws -> MovieListResponseDTO {
            fetchCallCount += 1
            return MovieListResponseDTO(dates: nil, page: 1, results: [], totalPages: 0, totalResults: 0)
        }
        
        func savePopular(_ movies: MovieListResponseDTO) async throws {
            savePopularCallCount += 1
            popularMovies = movies
        }
        
        func saveNowPlaying(_ movies: MovieListResponseDTO) async throws {
            saveNowPlayingCallCount += 1
            nowPlayingMovies = movies
        }
        
        func saveTopRated(_ movies: MovieListResponseDTO) async throws {}
        func saveUpcoming(_ movies: MovieListResponseDTO) async throws {}
    }
    
    func testGetPopularMovies_whenRemoteSucceeds_savesToLocalAndReturnsRemote() async throws {
        let remote = MockMovieDataSource()
        let local = MockMovieLocalDataSource()
        let decorator = MovieListDataSourceDecorator(remote: remote, local: local)

        let expectedMovies = [
            MovieResponseDTO(
                adult: false,
                backdropPath: nil,
                belongsToCollection: nil,
                budget: 0,
                genres: [],
                homepage: nil,
                id: 1,
                imdbId: nil,
                originCountry: [],
                originalLanguage: "en",
                originalTitle: "Test Movie",
                overview: "Overview",
                popularity: 1.0,
                posterPath: nil,
                productionCompanies: [],
                productionCountries: [],
                releaseDate: "2026-06-04",
                revenue: 0,
                runtime: nil,
                spokenLanguages: [],
                status: "Released",
                tagline: nil,
                title: "Test Movie",
                video: false,
                voteAverage: 1.0,
                voteCount: 1
            )
        ]
        let expectedResponse = MovieListResponseDTO(dates: nil, page: 1, results: expectedMovies, totalPages: 1, totalResults: 1)
        remote.result = .success(expectedResponse)
        
        let request = MovieListRequest(page: 1, language: "en", region: "")
        let result = try await decorator.getPopular(request: request)
        
        XCTAssertEqual(remote.callCount, 1)
        XCTAssertEqual(local.savePopularCallCount, 1)
        XCTAssertEqual(local.popularMovies.results.count, 1)
        XCTAssertEqual(result.results.first?.id, 1)
    }
    
    func testGetPopularMovies_whenRemoteFails_fallsBackToLocal() async throws {
        let remote = MockMovieDataSource()
        let local = MockMovieLocalDataSource()
        let decorator = MovieListDataSourceDecorator(remote: remote, local: local)

        let cachedMovies = [
            MovieResponseDTO(
                adult: false,
                backdropPath: nil,
                belongsToCollection: nil,
                budget: 0,
                genres: [],
                homepage: nil,
                id: 99,
                imdbId: nil,
                originCountry: [],
                originalLanguage: "en",
                originalTitle: "Cached Movie",
                overview: "Overview",
                popularity: 1.0,
                posterPath: nil,
                productionCompanies: [],
                productionCountries: [],
                releaseDate: "2026-06-04",
                revenue: 0,
                runtime: nil,
                spokenLanguages: [],
                status: "Released",
                tagline: nil,
                title: "Cached Movie",
                video: false,
                voteAverage: 1.0,
                voteCount: 1
            )
        ]
        let cachedResponse = MovieListResponseDTO(dates: nil, page: 1, results: cachedMovies, totalPages: 1, totalResults: 1)
        local.popularMovies = cachedResponse
        remote.result = .failure(URLError(.notConnectedToInternet))
        
        let request = MovieListRequest(page: 1, language: "en", region: "")
        let result = try await decorator.getPopular(request: request)
        
        XCTAssertEqual(remote.callCount, 1)
        XCTAssertEqual(local.fetchCallCount, 1)
        XCTAssertEqual(local.savePopularCallCount, 0)
        XCTAssertEqual(result.results.first?.id, 99)
    }
}
