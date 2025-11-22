//
//  PlanSectionCardSkeleton.swift
//  skillmate
//
//  Created by Gui Maggiorini on 22/11/25.
//

import SwiftUI

struct PlanSectionCardSkeleton: View {
    var body: some View {
        SkeletonView {
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 120, height: 20)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 180, height: 14)
                    }
                    Spacer()
                    Circle().frame(width: 20, height: 20)
                }
                
                VStack(spacing: 12) {
                    TaskRowSkeleton()
                    TaskRowSkeleton()
                    TaskRowSkeleton()
                }
            }
            .padding(.vertical, 8)
        }
    }
}
