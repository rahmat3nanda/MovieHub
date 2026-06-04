//
//  MovieRequest.swift
//  DomainKit
//
//  Created by Rahmat Trinanda Pramudya Amar on 04/06/26.
//

public struct MovieListRequest {
    public let page: Int
    public let language: String
    public let region: String

    public init(page: Int, language: String, region: String) {
        self.page = page
        self.language = language
        self.region = region
    }
}

public extension MovieListRequest {
    func toDictionary() -> [String: Any] {
        [
            "page": page,
            "language": language,
            "region": region
        ]
    }
}
