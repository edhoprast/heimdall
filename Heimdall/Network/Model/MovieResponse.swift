//
//  MovieResponse.swift
//  Heimdall
//
//  Created by Edho Prasetyo on 17/09/25.
//

public struct MovieResponse: Decodable, Equatable {
    public let totalPages: Int
    public let totalResults: Int
    public let page: Int
    public let movies: [Movies]
    
    public enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case page
        case movies = "results"
    }
}

public struct Movies: Decodable, Equatable {
    public let adult: Bool
    public let backdropPath: String?
    public let genreIds: [Int]
    public let id: Int
    public let originalLanguage: String
    public let originalTitle: String
    public let overview: String
    public let popularity: Double
    public let posterPath: String
    public let releaseDate: String
    /// Sometimes `title` is actually the converted original title to english/more general phrases
    public let title: String
    public let video: Bool
    
    public enum CodingKeys: String, CodingKey {
        case adult, id, popularity, overview, title, video
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
