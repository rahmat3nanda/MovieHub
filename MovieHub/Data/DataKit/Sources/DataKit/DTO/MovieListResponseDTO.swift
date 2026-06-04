import Foundation

public struct MovieListResponseDTO: Codable {
    public let dates: MovieListDatesResponseDTO?
    public let page: Int
    public let results: [MovieResponseDTO]
    public let totalPages: Int
    public let totalResults: Int
    
    public init(dates: MovieListDatesResponseDTO? = nil, page: Int, results: [MovieResponseDTO], totalPages: Int, totalResults: Int) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

public struct MovieListDatesResponseDTO: Codable {
    public let minimum: String
    public let maximum: String
    
    public init(minimum: String, maximum: String) {
        self.minimum = minimum
        self.maximum = maximum
    }
}
