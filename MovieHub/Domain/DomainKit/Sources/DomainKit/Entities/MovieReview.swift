import Foundation

public struct MovieReview: Equatable, Identifiable {
    public let id: String
    public let author: String
    public let authorDetails: MovieReviewAuthorDetails
    public let content: String
    public let createdAt: String
    public let updatedAt: String
    public let url: String

    public init(
        id: String,
        author: String,
        authorDetails: MovieReviewAuthorDetails,
        content: String,
        createdAt: String,
        updatedAt: String,
        url: String
    ) {
        self.id = id
        self.author = author
        self.authorDetails = authorDetails
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.url = url
    }
}

public struct MovieReviewAuthorDetails: Equatable {
    public let name: String
    public let username: String
    public let avatarPath: String?
    public let rating: Double?

    public init(name: String, username: String, avatarPath: String?, rating: Double?) {
        self.name = name
        self.username = username
        self.avatarPath = avatarPath
        self.rating = rating
    }
}
