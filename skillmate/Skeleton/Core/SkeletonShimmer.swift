//
//  SkeletonShimmer.swift
//  skillmate
//
//  Created by Gui Maggiorini on 22/11/25.
//

import SwiftUI

struct SkeletonShimmer: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    shimmerColor.opacity(0),
                                    shimmerColor.opacity(0.4),
                                    shimmerColor.opacity(0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width)
                        .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
                .clipped()
            }
            .onAppear {
                isAnimating = true
            }
    }
    
    private var shimmerColor: Color {
        colorScheme == .dark ? Color(.systemGray6) : .white
    }
}

extension View {
    func shimmer() -> some View {
        modifier(SkeletonShimmer())
    }
}
