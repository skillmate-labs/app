//
//  AuthInputView.swift
//  skillmate
//
//  Created by Gui Maggiorini on 15/11/25.
//

import SwiftUI

struct AuthInputField<Content: View>: View {
    let title: String
    let error: String?
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            content()
                .padding(16)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 48, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 48, style: .continuous)
                        .stroke(AuthValidation.borderColor(for: error), lineWidth: 1)
                }
            
            if let error {
                Label(error, systemImage: "exclamationmark.circle.fill")
                    .foregroundStyle(.red)
                    .font(.footnote)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
