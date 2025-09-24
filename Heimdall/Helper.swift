//
//  Helper.swift
//  Heimdall
//
//  Created by ByteDance on 9/24/25.
//

import Foundation
import UIKit

// MARK: - Image fetcher
public func fetchImage(_ urlString: String) async -> UIImage? {
    guard let url = URL(string: urlString) else { return nil }
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
        return UIImage(data: data)
    } catch {
        return nil
    }
}
