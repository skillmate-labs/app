//
//  APIConfiguration.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

enum APIConfiguration {
    private static let defaultBaseURL = "http://localhost:5289/api/v1"
    private static let key = "API_BASE_URL"
    
    static var baseURL: URL {
#if DEBUG
        if let value = ProcessInfo.processInfo.environment[key],
           let url = URL(string: value), !value.isEmpty {
            return url
        }
#endif
        
        if let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
           let url = URL(string: value), !value.isEmpty {
            return url
        }
        
        return URL(string: defaultBaseURL)!
    }
}
