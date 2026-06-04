//
//  File.swift
//  DataKit
//
//  Created by Rahmat Trinanda Pramudya Amar on 04/06/26.
//

import Foundation
import DomainKit

extension MovieListResponseDTO {
    public func toDomain() -> MovieList {
        MovieList(
            dates: dates?.toDomain(),
            page: page,
            results: results.map { $0.toDomain() },
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}

extension MovieListDatesResponseDTO {
    public func toDomain() -> MovieListDates {
        MovieListDates(minimum: minimum, maximum: maximum)
    }
}
