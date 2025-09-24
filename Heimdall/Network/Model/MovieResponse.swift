//
//  MovieResponse.swift
//  Heimdall
//
//  Created by Edho Prasetyo on 17/09/25.
//

import WidgetKit
import UIKit

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
    
    public func getTopNearestMovie() async -> MovieWidgetEntry? {
        guard !movies.isEmpty else { return nil }
        
        let threeMovies = Array(movies.filter { $0.backdropPath != nil && !$0.title.isEmpty }.prefix(3))
        
        var topMovies: [MovieWidget] = []
        
        var shouldShowSingleMovie: Bool = true
        var nearestMovieDate: Date?
        
        for data in threeMovies {
            guard !data.title.isEmpty, let dateConverted = data.releaseDate.stringToDate(), let backdropPath = data.backdropPath, !data.posterPath.isEmpty else { continue }
            
            if let nearestMovieDate {
                shouldShowSingleMovie = dateConverted.daysUntil(from: nearestMovieDate) > 30
            }else{
                nearestMovieDate = dateConverted
            }
            
            let countdown = dateConverted.daysUntil()
            
            let (backdropImage, posterImage) = await (fetchImage("https://image.tmdb.org/t/p/w780\(backdropPath)"), fetchImage("https://image.tmdb.org/t/p/w780\(data.posterPath)"))
            
            let subtitle: String?
            let dateTitle: String?
            let dateSubtitle: String?
            
            if countdown <= 0 {
                subtitle = "Now Playing"
                dateTitle = nil
                dateSubtitle = nil
            }else if countdown > 30 {
                subtitle = nil
                dateTitle = dateConverted.formatDate(format: "dd")
                dateSubtitle = dateConverted.formatDate(format: "MMM")
            }else{
                subtitle = dateConverted.formatDate()
                dateTitle = String(countdown)
                dateSubtitle = "days"
            }
            
            topMovies.append(
                MovieWidget(
                   title: data.title,
                   subtitle: subtitle,
                   dateTitle: dateTitle,
                   dateSubtitle: dateSubtitle,
                   backdropImage: backdropImage,
                   posterImage: posterImage
               )
            )
        }
        
        return MovieWidgetEntry(
            movies: topMovies,
            shouldShowSingleMovie: shouldShowSingleMovie
        )
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
    
    public init(
        adult: Bool = false,
        backdropPath: String? = nil,
        genreIds: [Int] = [],
        id: Int = 0,
        originalLanguage: String = "",
        originalTitle: String,
        overview: String = "",
        popularity: Double = 0.0,
        posterPath: String = "",
        releaseDate: String,
        title: String = "",
        video: Bool = false
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
    }
}

/// For WidgetKit
public struct MovieWidgetEntry: TimelineEntry {
    public var date: Date = Date()
    public let movies: [MovieWidget]
    /// This will only be `true` if the `nearest` movie date and the `second nearest` movie date are not away by a `month`
    public let shouldShowSingleMovie: Bool
}

public struct MovieWidget {
    public let title: String
    public let subtitle: String?
    public let dateTitle: String?
    public let dateSubtitle: String?
    public let backdropImage: UIImage?
    public let posterImage: UIImage?
}
