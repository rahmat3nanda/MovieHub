//
//  NetworkService.swift
//  MovieHub
//
//  Created by Antigravity on 03/06/26.
//

import Foundation

public protocol NetworkService {
    /// Decodes an API endpoint request asynchronously into the expected type.
    /// - Parameters:
    ///   - endpoint: Endpoint specification (url, method, headers, query parameters, body)
    /// - Returns: Decoded model of type `T`
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
