//
//  PlansRepository.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

final class PlansRepository {
    
    private let web = WebService()
    
    func generate(goalId: UUID) async throws -> WeeklyPlan? {
        try await web.request(
            .generatePlan(goalId: goalId),
            method: .PUT,
            decoderConfig: { decoder in decoder.dateDecodingStrategy = .iso8601 }
        )
    }
    
    func list(goalId: UUID, cursor: String?, limit: Int = 10) async throws -> PlansListResponse {
        try await web.request(
            .listPlans(goalId: goalId, cursor: cursor, limit: limit),
            method: .GET,
            decoderConfig: { decoder in decoder.dateDecodingStrategy = .iso8601 }
        )
    }
}
