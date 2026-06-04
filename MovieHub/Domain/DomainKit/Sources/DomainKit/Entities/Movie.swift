import Foundation

public struct Movie: Equatable, Identifiable {
    public let id: Int
    public let title: String
    public let originalTitle: String
    public let overview: String
    public let posterPath: String?
    public let backdropPath: String?
    public let releaseDate: String
    public let voteAverage: Double
    public let voteCount: Int
    public let popularity: Double
    public let genres: [Genre]
    public let runtime: Int?
    public let tagline: String?
    public let budget: Int64
    public let revenue: Int64
    public let homepage: String?
    public let status: String
    public let video: Bool
    public let adult: Bool
    public let originalLanguage: String
    public let originCountry: [String]
    public let belongsToCollection: MovieCollection?
    public let productionCompanies: [ProductionCompany]
    public let productionCountries: [ProductionCountry]
    public let spokenLanguages: [SpokenLanguage]
    
    public init(
        id: Int,
        title: String,
        originalTitle: String,
        overview: String,
        posterPath: String?,
        backdropPath: String?,
        releaseDate: String,
        voteAverage: Double,
        voteCount: Int,
        popularity: Double,
        genres: [Genre],
        runtime: Int?,
        tagline: String?,
        budget: Int64,
        revenue: Int64,
        homepage: String?,
        status: String,
        video: Bool,
        adult: Bool,
        originalLanguage: String,
        originCountry: [String],
        belongsToCollection: MovieCollection?,
        productionCompanies: [ProductionCompany],
        productionCountries: [ProductionCountry],
        spokenLanguages: [SpokenLanguage]
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.popularity = popularity
        self.genres = genres
        self.runtime = runtime
        self.tagline = tagline
        self.budget = budget
        self.revenue = revenue
        self.homepage = homepage
        self.status = status
        self.video = video
        self.adult = adult
        self.originalLanguage = originalLanguage
        self.originCountry = originCountry
        self.belongsToCollection = belongsToCollection
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.spokenLanguages = spokenLanguages
    }
}

public struct Genre: Equatable, Identifiable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct MovieCollection: Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let posterPath: String?
    public let backdropPath: String?
    
    public init(id: Int, name: String, posterPath: String?, backdropPath: String?) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
}

public struct ProductionCompany: Equatable, Identifiable {
    public let id: Int
    public let logoPath: String?
    public let name: String
    public let originCountry: String
    
    public init(id: Int, logoPath: String?, name: String, originCountry: String) {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
}

public struct ProductionCountry: Equatable {
    public let iso31661: String
    public let name: String
    
    public init(iso31661: String, name: String) {
        self.iso31661 = iso31661
        self.name = name
    }
}

public struct SpokenLanguage: Equatable {
    public let englishName: String
    public let iso6391: String
    public let name: String
    
    public init(englishName: String, iso6391: String, name: String) {
        self.englishName = englishName
        self.iso6391 = iso6391
        self.name = name
    }
}
