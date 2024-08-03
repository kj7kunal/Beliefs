//
//  CategoryFeedView.swift
//  Beliefs
//
//  Created by kunal.jain on 2024/08/03.
//

import SwiftUI

struct CategoryFeedView: View {
    var category: String
    @State private var beliefs: [Belief] = []

    var body: some View {
        List {
            ForEach(beliefs) { belief in
                VStack(alignment: .leading) {
                    Text(belief.title).font(.headline)
                    Text(belief.evidence).font(.subheadline).foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("\(category) Beliefs")
        .onAppear {
            beliefs = DatabaseManager.shared.fetchAllBeliefs().filter { $0.category == category }
        }
    }
}

struct CategoryFeedView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFeedView(category: "Sample Category")
    }
}
