//
//  SharedDataSource.swift
//  Heimdall
//
//  Created by Edho Prasetyo on 17/09/25.
//

import Foundation

public struct SharedDataStore {
    public enum ErrorTypes: Error {
        case message(String)
        case error(Error)
    }
    
    private static let tokenKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0OWFjZDRmMjNhN2UyNWIzMGM2OTk3ZmY4Y2UxNDg2MSIsIm5iZiI6MTQ1Mzg4MjY2OS43ODIsInN1YiI6IjU2YTg3ZDJkYzNhMzY4MjhjODAwMzZjNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.z-qmGtNf1gIhx6NFbTK6GKh9BbdM9mE1f_xQroVTjeo"
    private static let baseUrl = "https://api.themoviedb.org/3"

    public static func fetchData(completion: @escaping (Result<MovieResponse, ErrorTypes>) -> Void) {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let monthAfter = Calendar.current.date(byAdding: .month, value: 1, to: today) else {
            completion(.failure(.message("Failed to get date month after")))
            return
        }
        
        let todayString = formatter.string(from: today)
        let monthAfterString = formatter.string(from: monthAfter)
        
        guard let url = URL(string: "\(self.baseUrl)/discover/movie?region=ID&with_release_type=3&sort_by=release_date.asc&release_date.gte=\(todayString)&release_date.lte=\(monthAfterString)") else {
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
                    let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    /// Return fail here
                    completion(.failure(.message(error.localizedDescription)))
                }
            }
        }.resume()
    }
}
