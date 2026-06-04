// swiftlint:disable function_body_length line_length
import XCTest
import DomainKit
@testable import DataKit

final class MovieMappingTests: XCTestCase {
    
    func testMovieDecodingAndMapping() throws {
        let jsonString = """
        {
          "adult": false,
          "backdrop_path": "/2w4xG178RpB4MDAIfTkqAuSJzec.jpg",
          "belongs_to_collection": {
            "id": 10,
            "name": "Star Wars Collection",
            "poster_path": "/pWVLFh4OuejTpUaDQbB1C4zoS2p.jpg",
            "backdrop_path": "/iY2ujEY2m68OTTlPFTiHub9joHS.jpg"
          },
          "budget": 11000000,
          "genres": [
            {
              "id": 12,
              "name": "Adventure"
            },
            {
              "id": 28,
              "name": "Action"
            },
            {
              "id": 878,
              "name": "Science Fiction"
            }
          ],
          "homepage": "http://www.starwars.com/films/star-wars-episode-iv-a-new-hope",
          "id": 11,
          "imdb_id": "tt0076759",
          "origin_country": [
            "US"
          ],
          "original_language": "en",
          "original_title": "Star Wars",
          "overview": "Princess Leia is captured and held hostage by the evil Imperial forces in their effort to take over the galactic Empire. Venturesome Luke Skywalker and dashing captain Han Solo team together with the loveable robot duo R2-D2 and C-3PO to rescue the beautiful princess and restore peace and justice in the Empire.",
          "popularity": 20.6912,
          "poster_path": "/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg",
          "production_companies": [
            {
              "id": 1,
              "logo_path": "/tlVSws0RvvtPBwViUyOFAO0vcQS.png",
              "name": "Lucasfilm Ltd.",
              "origin_country": "US"
            },
            {
              "id": 25,
              "logo_path": "/qZCc1lty5FzX30aOCVRBLzaVmcp.png",
              "name": "20th Century Fox",
              "origin_country": "US"
            }
          ],
          "production_countries": [
            {
              "iso_3166_1": "US",
              "name": "United States of America"
            }
          ],
          "release_date": "1977-05-25",
          "revenue": 775398007,
          "runtime": 121,
          "spoken_languages": [
            {
              "english_name": "English",
              "iso_639_1": "en",
              "name": "English"
            }
          ],
          "status": "Released",
          "tagline": "A long time ago in a galaxy far, far away...",
          "title": "Star Wars",
          "video": false,
          "vote_average": 8.2,
          "vote_count": 22061
        }
        """
        
        let jsonData = try XCTUnwrap(jsonString.data(using: .utf8))
        
        // Test Decoding
        let decoder = JSONDecoder()
        let dto = try decoder.decode(MovieResponseDTO.self, from: jsonData)
        
        XCTAssertEqual(dto.id, 11)
        XCTAssertEqual(dto.title, "Star Wars")
        XCTAssertEqual(dto.adult, false)
        XCTAssertEqual(dto.backdropPath, "/2w4xG178RpB4MDAIfTkqAuSJzec.jpg")
        
        let collection = try XCTUnwrap(dto.belongsToCollection)
        XCTAssertEqual(collection.id, 10)
        XCTAssertEqual(collection.name, "Star Wars Collection")
        XCTAssertEqual(collection.posterPath, "/pWVLFh4OuejTpUaDQbB1C4zoS2p.jpg")
        XCTAssertEqual(collection.backdropPath, "/iY2ujEY2m68OTTlPFTiHub9joHS.jpg")
        
        XCTAssertEqual(dto.budget, 11000000)
        XCTAssertEqual(dto.genres.count, 3)
        XCTAssertEqual(dto.genres[0].id, 12)
        XCTAssertEqual(dto.genres[0].name, "Adventure")
        XCTAssertEqual(dto.genres[1].id, 28)
        XCTAssertEqual(dto.genres[1].name, "Action")
        XCTAssertEqual(dto.genres[2].id, 878)
        XCTAssertEqual(dto.genres[2].name, "Science Fiction")
        
        XCTAssertEqual(dto.homepage, "http://www.starwars.com/films/star-wars-episode-iv-a-new-hope")
        XCTAssertEqual(dto.imdbId, "tt0076759")
        XCTAssertEqual(dto.originCountry, ["US"])
        XCTAssertEqual(dto.originalLanguage, "en")
        XCTAssertEqual(dto.originalTitle, "Star Wars")
        XCTAssertEqual(dto.overview, "Princess Leia is captured and held hostage by the evil Imperial forces in their effort to take over the galactic Empire. Venturesome Luke Skywalker and dashing captain Han Solo team together with the loveable robot duo R2-D2 and C-3PO to rescue the beautiful princess and restore peace and justice in the Empire.")
        XCTAssertEqual(dto.popularity, 20.6912)
        XCTAssertEqual(dto.posterPath, "/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg")
        
        XCTAssertEqual(dto.productionCompanies.count, 2)
        XCTAssertEqual(dto.productionCompanies[0].id, 1)
        XCTAssertEqual(dto.productionCompanies[0].name, "Lucasfilm Ltd.")
        XCTAssertEqual(dto.productionCompanies[0].logoPath, "/tlVSws0RvvtPBwViUyOFAO0vcQS.png")
        XCTAssertEqual(dto.productionCompanies[0].originCountry, "US")
        XCTAssertEqual(dto.productionCompanies[1].id, 25)
        XCTAssertEqual(dto.productionCompanies[1].name, "20th Century Fox")
        XCTAssertEqual(dto.productionCompanies[1].logoPath, "/qZCc1lty5FzX30aOCVRBLzaVmcp.png")
        XCTAssertEqual(dto.productionCompanies[1].originCountry, "US")
        
        XCTAssertEqual(dto.productionCountries.count, 1)
        XCTAssertEqual(dto.productionCountries[0].iso31661, "US")
        XCTAssertEqual(dto.productionCountries[0].name, "United States of America")
        
        XCTAssertEqual(dto.releaseDate, "1977-05-25")
        XCTAssertEqual(dto.revenue, 775398007)
        XCTAssertEqual(dto.runtime, 121)
        
        XCTAssertEqual(dto.spokenLanguages.count, 1)
        XCTAssertEqual(dto.spokenLanguages[0].englishName, "English")
        XCTAssertEqual(dto.spokenLanguages[0].iso6391, "en")
        XCTAssertEqual(dto.spokenLanguages[0].name, "English")
        
        XCTAssertEqual(dto.status, "Released")
        XCTAssertEqual(dto.tagline, "A long time ago in a galaxy far, far away...")
        XCTAssertEqual(dto.video, false)
        XCTAssertEqual(dto.voteAverage, 8.2)
        XCTAssertEqual(dto.voteCount, 22061)
        
        // Test Mapping to Domain
        let movie = dto.toDomain()
        
        XCTAssertEqual(movie.id, 11)
        XCTAssertEqual(movie.title, "Star Wars")
        XCTAssertEqual(movie.adult, false)
        XCTAssertEqual(movie.backdropPath, "/2w4xG178RpB4MDAIfTkqAuSJzec.jpg")
        
        let movieCollection = try XCTUnwrap(movie.belongsToCollection)
        XCTAssertEqual(movieCollection.id, 10)
        XCTAssertEqual(movieCollection.name, "Star Wars Collection")
        XCTAssertEqual(movieCollection.posterPath, "/pWVLFh4OuejTpUaDQbB1C4zoS2p.jpg")
        XCTAssertEqual(movieCollection.backdropPath, "/iY2ujEY2m68OTTlPFTiHub9joHS.jpg")
        
        XCTAssertEqual(movie.budget, 11000000)
        XCTAssertEqual(movie.genres.count, 3)
        XCTAssertEqual(movie.genres[0].id, 12)
        XCTAssertEqual(movie.genres[0].name, "Adventure")
        XCTAssertEqual(movie.genres[1].id, 28)
        XCTAssertEqual(movie.genres[1].name, "Action")
        XCTAssertEqual(movie.genres[2].id, 878)
        XCTAssertEqual(movie.genres[2].name, "Science Fiction")
        
        XCTAssertEqual(movie.homepage, "http://www.starwars.com/films/star-wars-episode-iv-a-new-hope")
        XCTAssertEqual(movie.originCountry, ["US"])
        XCTAssertEqual(movie.originalLanguage, "en")
        XCTAssertEqual(movie.originalTitle, "Star Wars")
        XCTAssertEqual(movie.overview, "Princess Leia is captured and held hostage by the evil Imperial forces in their effort to take over the galactic Empire. Venturesome Luke Skywalker and dashing captain Han Solo team together with the loveable robot duo R2-D2 and C-3PO to rescue the beautiful princess and restore peace and justice in the Empire.")
        XCTAssertEqual(movie.popularity, 20.6912)
        XCTAssertEqual(movie.posterPath, "/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg")
        
        XCTAssertEqual(movie.productionCompanies.count, 2)
        XCTAssertEqual(movie.productionCompanies[0].id, 1)
        XCTAssertEqual(movie.productionCompanies[0].name, "Lucasfilm Ltd.")
        XCTAssertEqual(movie.productionCompanies[0].logoPath, "/tlVSws0RvvtPBwViUyOFAO0vcQS.png")
        XCTAssertEqual(movie.productionCompanies[0].originCountry, "US")
        XCTAssertEqual(movie.productionCompanies[1].id, 25)
        XCTAssertEqual(movie.productionCompanies[1].name, "20th Century Fox")
        XCTAssertEqual(movie.productionCompanies[1].logoPath, "/qZCc1lty5FzX30aOCVRBLzaVmcp.png")
        XCTAssertEqual(movie.productionCompanies[1].originCountry, "US")
        
        XCTAssertEqual(movie.productionCountries.count, 1)
        XCTAssertEqual(movie.productionCountries[0].iso31661, "US")
        XCTAssertEqual(movie.productionCountries[0].name, "United States of America")
        
        XCTAssertEqual(movie.releaseDate, "1977-05-25")
        XCTAssertEqual(movie.revenue, 775398007)
        XCTAssertEqual(movie.runtime, 121)
        
        XCTAssertEqual(movie.spokenLanguages.count, 1)
        XCTAssertEqual(movie.spokenLanguages[0].englishName, "English")
        XCTAssertEqual(movie.spokenLanguages[0].iso6391, "en")
        XCTAssertEqual(movie.spokenLanguages[0].name, "English")
        
        XCTAssertEqual(movie.status, "Released")
        XCTAssertEqual(movie.tagline, "A long time ago in a galaxy far, far away...")
        XCTAssertEqual(movie.video, false)
        XCTAssertEqual(movie.voteAverage, 8.2)
        XCTAssertEqual(movie.voteCount, 22061)
    }
}
