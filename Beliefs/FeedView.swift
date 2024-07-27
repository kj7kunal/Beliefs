//
//  FeedView.swift
//  Beliefs
//
//  Created by kunal.jain on 2024/07/27.
//

import SwiftUI

struct FeedView: View {
    @State private var beliefs: [Belief] = []
    @State private var selectedSortOption = "Date"
    @State private var filterText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Filter", text: $filterText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Menu {
                        Button("Date", action: { selectedSortOption = "Date"; sortBeliefs() })
                        Button("Title", action: { selectedSortOption = "Title"; sortBeliefs() })
                    } label: {
                        Text("Sort by \(selectedSortOption)")
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                
                List {
                    ForEach(beliefs.filter { $0.title.contains(filterText) || filterText.isEmpty }) { belief in
                        VStack(alignment: .leading) {
                            Text(belief.title).font(.headline)
                            Text(belief.evidence).font(.subheadline).foregroundColor(.gray)
                        }
                    }
                }
                .onAppear {
                    refreshBeliefs()
                }
            }
            .navigationTitle("Beliefs Feed")
            .navigationBarItems(trailing: Button("Refresh") {
                refreshBeliefs()
            })
        }
    }
    
    private func refreshBeliefs() {
        beliefs = DatabaseManager.shared.fetchAllBeliefs()
        sortBeliefs()
    }
    
    private func sortBeliefs() {
        switch selectedSortOption {
        case "Date":
            beliefs.sort { $0.id > $1.id }
        case "Title":
            beliefs.sort { $0.title.lowercased() < $1.title.lowercased() }
        default:
            break
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
