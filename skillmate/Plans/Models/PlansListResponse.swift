//
//  PlansListResponse.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct PlansListResponse: Codable {
    let data: [PlanSummary]
    let pageInfo: PageInfo
    
    struct PageInfo: Codable {
        let nextCursor: String?
        let hasNextPage: Bool
    }
}
