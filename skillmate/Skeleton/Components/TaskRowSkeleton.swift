//
//  TaskRowSkeleton.swift
//  skillmate
//
//  Created by Gui Maggiorini on 22/11/25.
//

import SwiftUI

struct TaskRowSkeleton: View {
    var body: some View {
        SkeletonView {
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(height: 16)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 80, height: 12)
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
}
