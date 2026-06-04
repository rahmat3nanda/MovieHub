//
//  MovieListResponseDTO.swift
//  DataKit
//
//  Created by Rahmat Trinanda Pramudya Amar on 04/06/26.
//

public struct MovieListResponseDTO: Codable {
    public let dates: MovieListDatesResponseDTO?
    public let page: Int
    public let results: [MovieResponseDTO]
}

public struct MovieListDatesResponseDTO: Codable {
    public let minimum: String
    public let maximum: String
}
