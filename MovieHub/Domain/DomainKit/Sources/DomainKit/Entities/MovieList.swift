//
//  MovieList.swift
//  DataKit
//
//  Created by Rahmat Trinanda Pramudya Amar on 04/06/26.
//

import Foundation

public struct MovieList: Equatable {
    public let dates: MovieListDates?
    public let page: Int
    public let results: [Movie]

    public init(dates: MovieListDates?, page: Int, results: [Movie]) {
        self.dates = dates
        self.page = page
        self.results = results
    }
}

public struct MovieListDates: Equatable {
    public let minimum: String
    public let maximum: String

    public init(minimum: String, maximum: String) {
        self.minimum = minimum
        self.maximum = maximum
    }
}
