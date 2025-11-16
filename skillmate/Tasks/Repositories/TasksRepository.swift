//
//  TasksRepository.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

final class TasksRepository {
    
    private let web = WebService()
    
    func list(planId: UUID, cursor: String?, limit: Int = 10) async throws -> TaskResponse {
        try await web.request(
            .listTasks(planId: planId, cursor: cursor, limit: limit),
            method: .GET,
            decoderConfig: { decoder in
                decoder.dateDecodingStrategy = .iso8601
            }
        )
    }
    
    func update(taskId: UUID, body: UpdateTaskRequest) async throws -> TaskItem {
        try await web.request(
            .updateTask(id: taskId),
            method: .PATCH,
            body: body,
            decoderConfig: { decoder in
                decoder.dateDecodingStrategy = .iso8601
            }
        )
    }
}
