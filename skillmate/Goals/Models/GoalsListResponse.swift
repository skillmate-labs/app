//
//  GoalsListResponse.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct GoalsListResponse: Decodable {
    let data: [Goal]
    let pageInfo: PageInfo
}

struct PageInfo: Decodable {
    let nextCursor: String?
    let hasNextPage: Bool
}
