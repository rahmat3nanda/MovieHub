//
//  AppDelegate+Registration.swift
//  MovieHub
//
//  Created by Rahmat Trinanda Pramudya Amar on 03/06/26.
//

import DIContainer
import NetworkManager
import Persistence
import SharedUI
import DomainKit
import DataKit

extension AppDelegate {
    func register() {
        DIContainer.shared.register(NetworkService.self, dependency: URLSessionNetworkService())
        DIContainer.shared.register(Storage.self, dependency: UserDefaultsStorage())
        DIContainer.shared.register(ToastService.self, dependency: DefaultToastService())
        
        let remote = DefaultMovieListRemoteDataSource()
        let local = DefaultMovieListLocalDataSource()
        let decorator = MovieListDataSourceDecorator(remote: remote, local: local)
        let repository = DefaultMovieListRepository(dataSource: decorator)
        
        DIContainer.shared.register(MovieListRepository.self, dependency: repository)
        DIContainer.shared.register(GetNowPlayingMoviesUseCase.self, dependency: GetNowPlayingMoviesUseCase(repository: repository))
        DIContainer.shared.register(GetPopularMoviesUseCase.self, dependency: GetPopularMoviesUseCase(repository: repository))
        DIContainer.shared.register(GetTopRatedMoviesUseCase.self, dependency: GetTopRatedMoviesUseCase(repository: repository))
        DIContainer.shared.register(GetUpcomingMoviesUseCase.self, dependency: GetUpcomingMoviesUseCase(repository: repository))
    }
}
