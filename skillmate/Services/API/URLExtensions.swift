//
//  URLExtensions.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

extension URL {
    func appendingQueryItems(_ items: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        components.queryItems = items
        return components.url!
    }
}
