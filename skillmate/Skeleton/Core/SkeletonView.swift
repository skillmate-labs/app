//
//  SkeletonView.swift
//  skillmate
//
//  Created by Gui Maggiorini on 22/11/25.
//

import SwiftUI

struct SkeletonView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let content: () -> Content
    
    var body: some View {
        content()
            .redacted(reason: .placeholder)
            .foregroundStyle(skeletonColor)
            .shimmer()
            .transition(.opacity)
    }
    
    private var skeletonColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2)
    }
}
