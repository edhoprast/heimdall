//
//  SharedDataSource.swift
//  Heimdall
//
//  Created by Edho Prasetyo on 17/09/25.
//

import Foundation

public struct MovieResponse: Equatable {
    
}
public struct SharedDataStore {
    public enum ErrorTypes: Error {
        case message(String)
        case error(Error)
    }
    
    private static let tokenKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0OWFjZDRmMjNhN2UyNWIzMGM2OTk3ZmY4Y2UxNDg2MSIsIm5iZiI6MTQ1Mzg4MjY2OS43ODIsInN1YiI6IjU2YTg3ZDJkYzNhMzY4MjhjODAwMzZjNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.z-qmGtNf1gIhx6NFbTK6GKh9BbdM9mE1f_xQroVTjeo"
    private static let baseUrl = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_release_type=2|3&release_date.gte={min_date}&release_date.lte={max_date}"
    
    public static func fetchData(completion: @escaping (Result<String, ErrorTypes>) -> Void) {
        guard let url = URL(string: "\(self.baseUrl)/movie/upcoming?language=en-US&page=1&region=ID") else {
            /// Return fail here
            completion(.failure(.message("URL Not Found")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(self.tokenKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                /// Return fail here
                completion(.failure(.message(error.localizedDescription)))
                return
            }
            
            if let data = data {
                do {
                    
                } catch {
                    /// Return fail here
                    completion(.failure(.message(error.localizedDescription)))
                }
            }
        }.resume()
    }
}
