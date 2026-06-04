import Constants
import Foundation

public protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }

    var headers: [String: String]? { get }
    var queryParameters: [String: Any]? { get }
    var bodyParameters: [String: Any]? { get }
}

public extension Endpoint {
    var baseURL: URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: APIConstants.baseURL)!
    }

    var headers: [String: String]? {
        [
            "accept": "application/json",
            "Authorization": "Bearer \(APIConstants.apiKey)"
        ]
    }

    var queryParameters: [String: Any]? {
        nil
    }

    var bodyParameters: [String: Any]? {
        nil
    }
}

extension Endpoint {
    /// Helper to convert Endpoint to URLRequest.
    public func urlRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw NetworkError.invalidURL
            }
            let queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
            guard let updatedURL = urlComponents.url else {
                throw NetworkError.invalidURL
            }
            url = updatedURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let bodyParameters = bodyParameters, !bodyParameters.isEmpty {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
                if request.value(forHTTPHeaderField: "Content-Type") == nil {
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                throw NetworkError.underlying(error)
            }
        }
        
        return request
    }
}
