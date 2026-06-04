import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodeError(Error)
    case serverError(statusCode: Int)
    case underlying(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .noData:
            return "No data was returned from the server."
        case .decodeError(let error):
            return "Failed to parse network response: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server returned error response (Status code: \(statusCode))"
        case .underlying(let error):
            return error.localizedDescription
        }
    }
}
