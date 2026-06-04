import Foundation
import UtilityKit

public final class ConsoleNetworkLogger {
    
    static func log(request: URLRequest) {
        printDebug("\n==================================================")
        printDebug("🌐 [Request] \(request.httpMethod ?? "GET") -> \(request.url?.absoluteString ?? "")")
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            printDebug("👤 Headers: \(headers)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            printDebug("📦 Body: \(bodyString)")
        }
        printDebug("==================================================")
    }

    static func log(response: URLResponse, data: Data) {
        printDebug("\n==================================================")
        if let httpResponse = response as? HTTPURLResponse {
            let emoji = (200...299).contains(httpResponse.statusCode) ? "🟢" : "🔴"
            printDebug("\(emoji) [Response] \(httpResponse.statusCode) <- \(response.url?.absoluteString ?? "")")
        } else {
            printDebug("🟢 [Response] <- \(response.url?.absoluteString ?? "")")
        }

        // printDebug formatted JSON if possible
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            printDebug("📦 Payload:\n\(prettyString)")
        } else if let fallbackString = String(data: data, encoding: .utf8) {
            printDebug("📦 Payload: \(fallbackString)")
        }
        printDebug("==================================================")
    }

    static func log(error: Error, for request: URLRequest) {
        printDebug("\n==================================================")
        printDebug("🔴 [Error] <- \(request.url?.absoluteString ?? "")")
        printDebug("❌ Description: \(error.localizedDescription)")
        printDebug("==================================================")
    }
}
