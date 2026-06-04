import Foundation
import DomainKit

extension MovieResponseDTO {
    public func toDomain() -> Movie {
        return Movie(
            id: id,
            title: title,
            originalTitle: originalTitle,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            voteCount: voteCount,
            popularity: popularity,
            genres: genres?.map { $0.toDomain() },
            runtime: runtime,
            tagline: tagline,
            budget: budget,
            revenue: revenue,
            homepage: homepage,
            status: status,
            video: video,
            adult: adult,
            originalLanguage: originalLanguage,
            originCountry: originCountry,
            belongsToCollection: belongsToCollection?.toDomain(),
            productionCompanies: productionCompanies?.map { $0.toDomain() },
            productionCountries: productionCountries?.map { $0.toDomain() },
            spokenLanguages: spokenLanguages?.map { $0.toDomain() }
        )
    }
}

extension GenreDTO {
    public func toDomain() -> Genre {
        return Genre(id: id, name: name)
    }
}

extension CollectionDTO {
    public func toDomain() -> MovieCollection {
        return MovieCollection(
            id: id,
            name: name,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }
}

extension ProductionCompanyDTO {
    public func toDomain() -> ProductionCompany {
        return ProductionCompany(
            id: id,
            logoPath: logoPath,
            name: name,
            originCountry: originCountry
        )
    }
}

extension ProductionCountryDTO {
    public func toDomain() -> ProductionCountry {
        return ProductionCountry(
            iso31661: iso31661,
            name: name
        )
    }
}

extension SpokenLanguageDTO {
    public func toDomain() -> SpokenLanguage {
        return SpokenLanguage(
            englishName: englishName,
            iso6391: iso6391,
            name: name
        )
    }
}
