//
//  Reference.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct ReferenceCard: View {
    var reference: Reference
    
    var body: some View {
        Link(destination: URL(string: reference.link)!) {
            HStack {
                VStack(alignment: .leading) {
                    Text(reference.name)
                    
                    Text(reference.description)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.systemGray2))
            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    NavigationStack {
        List {
            ReferenceCard(reference: Reference(
                id: UUID(),
                name: "Useful reference",
                description: "This reference is very very useful and you should definetly check it out",
                link: "https://github.com/arthvm",
            ))

        }
    }
}
