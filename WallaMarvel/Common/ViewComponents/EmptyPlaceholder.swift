//
//  EmptyPlaceholder.swift
//  Hoop
//
//  Created by Fatima Syed on 30/7/25.
//

import SwiftUI

enum EmptyPlaceholderType {
    case empty
    case error(retryAction: () -> Void)

    var image: Image {
        switch self {
        case .empty:
            Image(.empty)
        case .error:
            Image(.error)
        }
    }

    var title: String {
        switch self {
        case .empty:
            "No results"
        case .error:
            "Error"
        }
    }

    var description: String {
        switch self {
        case .empty:
            "There are no results found"
        case .error:
            "Error loading information, please try again later"
        }
    }
    
    var accessibilityImageLabel: String {
        switch self {
        case .empty:
            "Empty state illustration"
        case .error:
            "Error illustration"
        }
    }
}

struct EmptyPlaceholder: View {
    var type: EmptyPlaceholderType

    var body: some View {
        VStack(spacing: Spacing.small) {
            Text(type.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(type.description)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            type.image
                .style(size: 150)
                .padding(.bottom, Spacing.small)
                .accessibilityLabel(type.accessibilityImageLabel)
            
            if case .error(let retry) = type {
                Button("Try again") {
                    retry()
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Try again button")
                .accessibilityHint("Double tap to retry loading")
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(Spacing.medium)
    }
}

#Preview {
    EmptyPlaceholder(type: .empty)
}
