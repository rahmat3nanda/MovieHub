import Foundation

public struct MovieReviewList: Equatable, Identifiable {
    public let id: Int
    public let page: Int
    public let results: [MovieReview]
    public let totalPages: Int
    public let totalResults: Int

    public init(id: Int, page: Int, results: [MovieReview], totalPages: Int, totalResults: Int) {
        self.id = id
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
