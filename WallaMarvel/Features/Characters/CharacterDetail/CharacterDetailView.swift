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
            VStack(alignment: .leading, spacing: 16) {
                ImageView(imageUrl: character.imageUrl, size: 250)
                    .frame(maxWidth: .infinity)
                    //.ignoresSafeArea()
                
                Text(character.films.joined(separator: ", "))
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
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
