//
//  WebService.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation
import FirebaseAuth

enum HTTPMethod: String {
    case GET, POST, PATCH, PUT, DELETE
}

final class WebService {
    
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        method: HTTPMethod = .GET,
        body: Encodable? = nil,
        requiresAuth: Bool = true,
        decoderConfig: ((JSONDecoder) -> Void)? = nil
    ) async throws -> T {
        
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if requiresAuth {
            if let user = Auth.auth().currentUser,
               let token = try? await user.getIDToken() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.badResponse
        }
        
        guard (200..<300).contains(http.statusCode) else {
            throw NetworkError.badStatus(code: http.statusCode, data: data)
        }
        
        if data.isEmpty {
            if let optionalMeta = T.self as? AnyOptional.Type {
                return optionalMeta.nilValue as! T
            }
            if T.self == Empty.self {
                return Empty() as! T
            }
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        decoderConfig?(decoder)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.failedToDecodeResponse
        }
    }
}

private protocol AnyOptional {
    static var nilValue: Any { get }
}

extension Optional: AnyOptional {
    static var nilValue: Any { Self.none as Any }
}

struct Empty: Decodable {}
