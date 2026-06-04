import Foundation
import DomainKit

extension MovieReviewResponseDTO {
    public func toDomain() -> MovieReview {
        return MovieReview(
            id: id,
            author: author,
            authorDetails: authorDetails.toDomain(),
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            url: url
        )
    }
}

extension MovieReviewAuthorDetailsResponseDTO {
    public func toDomain() -> MovieReviewAuthorDetails {
        return MovieReviewAuthorDetails(
            name: name,
            username: username,
            avatarPath: avatarPath,
            rating: rating
        )
    }
}
