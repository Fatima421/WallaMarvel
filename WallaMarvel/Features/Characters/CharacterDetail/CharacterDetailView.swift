//
//  CharacterDetailView.swift
//  WallaMarvel
//
//  Created by Fatima Syed on 1/2/26.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                ImageView(imageUrl: character.imageUrl, size: 300)
                    .frame(maxWidth: .infinity)
                
                if !character.films.isEmpty {
                    informationSection
                }
            }
            .padding(.horizontal, Spacing.medium)
        }
        .scrollIndicators(.hidden)
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text("Films")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(character.films, id: \.self) { film in
                Text(film)
                    .font(.headline)
            }
        }

    }
}

#Preview {
    CharacterDetailView(
        character: Character(
            from: CharacterDataModel(
                id: 1,
                name: "Mickey Mouse",
                imageUrl: "https://picsum.photos/200/300",
                films: []
            )
        )
    )
}
