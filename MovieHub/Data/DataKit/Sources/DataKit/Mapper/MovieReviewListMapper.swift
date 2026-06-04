import Foundation
import DomainKit

extension MovieReviewListResponseDTO {
    public func toDomain() -> MovieReviewList {
        return MovieReviewList(
            id: id,
            page: page,
            results: results.map { $0.toDomain() },
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}
