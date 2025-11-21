//
//  GoalsRepository.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

final class GoalsRepository {
    private let web = WebService()
    
    // MARK: - Create
    func create(_ req: Goal) async throws -> Goal {
        try await web.request(
            .goals,
            method: .POST,
            body: req,
            decoderConfig: { decoder in
                decoder.dateDecodingStrategy = .iso8601
            }
        )
    }
    
    // MARK: - Get All
    func getAll(cursor: String? = nil, limit: Int = 10) async throws -> GoalsListResponse {
        try await web.request(
            .listGoals(cursor: cursor, limit: limit),
            method: .GET,
            decoderConfig: { decoder in
                decoder.dateDecodingStrategy = .iso8601
            }
        )
    }
    
    // MARK: - Update
    struct UpdateGoalRequest: Encodable {
        let hoursPerDay: Int?
        let daysPerWeek: Int?
    }
    
    func update(_ goalId: UUID, with req: UpdateGoalRequest) async throws -> Goal {
        try await web.request(
            .goal(id: goalId),
            method: .PATCH,
            body: req,
            decoderConfig: { decoder in
                decoder.dateDecodingStrategy = .iso8601
            }
        )
    }
    
    // MARK: - Delete
    func delete(_ goalId: UUID) async throws {
        _ = try await web.request(
            .goal(id: goalId),
            method: .DELETE,
            decoderConfig: nil
        ) as Empty
    }
}
