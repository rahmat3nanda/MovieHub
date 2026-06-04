import Foundation

public struct MovieReviewResponseDTO: Codable {
    public let author: String
    public let authorDetails: MovieReviewAuthorDetailsResponseDTO
    public let content: String
    public let createdAt: String
    public let id: String
    public let updatedAt: String
    public let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

public struct MovieReviewAuthorDetailsResponseDTO: Codable {
    public let name: String
    public let username: String
    public let avatarPath: String?
    public let rating: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}
