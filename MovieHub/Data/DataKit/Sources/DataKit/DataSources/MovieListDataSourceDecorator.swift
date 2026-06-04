import Foundation
import DomainKit
import UtilityKit

public final class MovieListDataSourceDecorator: MovieListDataSource {
    private let remote: MovieListDataSource
    private let local: MovieListLocalDataSource

    public init(remote: MovieListDataSource, local: MovieListLocalDataSource) {
        self.remote = remote
        self.local = local
    }

    public func getPopular(request: MovieListRequest) async throws -> MovieListResponseDTO {
        do {
            let remoteMovies = try await remote.getPopular(request: request)
            try? await local.savePopular(remoteMovies)
            return remoteMovies
        } catch {
            printDebug("woiii", error)
            return try await local.getPopular(request: request)
        }
    }
    
    public func getNowPlaying(request: MovieListRequest) async throws -> MovieListResponseDTO {
        do {
            let remoteMovies = try await remote.getNowPlaying(request: request)
            try? await local.saveNowPlaying(remoteMovies)
            return remoteMovies
        } catch {
            return try await local.getNowPlaying(request: request)
        }
    }
    
    public func getTopRated(request: MovieListRequest) async throws -> MovieListResponseDTO {
        do {
            let remoteMovies = try await remote.getTopRated(request: request)
            try? await local.saveTopRated(remoteMovies)
            return remoteMovies
        } catch {
            return try await local.getTopRated(request: request)
        }
    }
    
    public func getUpcoming(request: MovieListRequest) async throws -> MovieListResponseDTO {
        do {
            let remoteMovies = try await remote.getUpcoming(request: request)
            try? await local.saveUpcoming(remoteMovies)
            return remoteMovies
        } catch {
            return try await local.getUpcoming(request: request)
        }
    }
}
