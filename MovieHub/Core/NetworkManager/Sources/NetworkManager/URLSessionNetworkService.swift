import Foundation
import Pulse

public final class URLSessionNetworkService: NetworkService {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    public init(session: URLSession? = nil, decoder: JSONDecoder = JSONDecoder()) {
        if let session = session {
            self.session = session
        } else {
            #if DEBUG
            let configuration = URLSessionConfiguration.default
            let delegate = URLSessionProxyDelegate()
            self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
            #else
            self.session = .shared
            #endif
        }
        self.decoder = decoder
    }
    
    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = try endpoint.urlRequest()
        
        ConsoleNetworkLogger.log(request: request)
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            ConsoleNetworkLogger.log(error: error, for: request)
            throw NetworkError.underlying(error)
        }
        
        ConsoleNetworkLogger.log(response: response, data: data)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(statusCode: 0)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodeError(error)
        }
    }
}
