import Foundation

public struct MovieReviewListResponseDTO: Codable {
    public let id: Int
    public let page: Int
    public let results: [MovieReviewResponseDTO]
    public let totalPages: Int
    public let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
