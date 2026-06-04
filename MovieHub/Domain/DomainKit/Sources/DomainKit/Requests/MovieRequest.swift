import Foundation

public struct MovieRequest {
    public let id: Int
    public let page: Int

    public init(id: Int, page: Int = 1) {
        self.id = id
        self.page = page
    }
}
