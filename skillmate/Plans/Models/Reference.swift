//
//  Reference.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct Reference: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let link: String
}
