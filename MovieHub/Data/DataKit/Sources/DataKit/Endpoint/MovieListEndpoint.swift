//
//  MovieListEndpoint.swift
//  DataKit
//
//  Created by Rahmat Trinanda Pramudya Amar on 04/06/26.
//

import DomainKit
import NetworkManager

public enum MovieListEndpoint: Endpoint {
    case nowPlaying(MovieListRequest)
    case popular(MovieListRequest)
    case topRated(MovieListRequest)
    case upcoming(MovieListRequest)

    public var path: String {
        switch self {
        case .nowPlaying: "3/movie/now_playing"
        case .popular: "3/movie/popular"
        case .topRated: "3/movie/top_rated"
        case .upcoming: "3/movie/upcoming"
        }
    }
    
    public var method: NetworkManager.HTTPMethod {
        switch self {
        case .nowPlaying, .popular, .topRated, .upcoming: .get
        }
    }

    public var queryParameters: [String : Any]? {
        switch self {
        case let .nowPlaying(request): request.toDictionary()
        case let .popular(request): request.toDictionary()
        case let .topRated(request): request.toDictionary()
        case let .upcoming(request): request.toDictionary()
        }
    }
}
