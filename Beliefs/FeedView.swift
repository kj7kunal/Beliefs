import SwiftUI

struct FeedView: View {
    @State private var beliefs: [Belief] = []
    @State private var categories: [Category] = []
    @State private var selectedSortOption = "Date"
    @State private var selectedFilterCategory = "All"
    @State private var filterText = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Filter", text: $filterText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Menu {
                        Button("All", action: { selectedFilterCategory = "All"; refreshBeliefs() })
                        ForEach(categories.map { $0.name }, id: \.self) { category in
                            Button(category, action: { selectedFilterCategory = category; refreshBeliefs() })
                        }
                    } label: {
                        Text("Filter: \(selectedFilterCategory)")
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
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
                            HStack {
                                NavigationLink(destination: CategoryFeedView(category: belief.category)) {
                                    Text(belief.title).font(.headline)
                                    Spacer()
                                    Text(belief.category)
                                        .padding(5)
                                        .background(Color.yellow.opacity(0.5))
                                        .cornerRadius(5)
                                }
                            }
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
        categories = DatabaseManager.shared.fetchAllCategories()
        if selectedFilterCategory != "All" {
            beliefs = beliefs.filter { $0.category == selectedFilterCategory }
        }
        sortBeliefs()
    }
    
    private func sortBeliefs() {
        switch selectedSortOption {
        case "Date":
            beliefs.sort { $0.id > $1.id }
        case "Title":
            beliefs.sort { $0.title.lowercased() < $1.title.lowercased() }
        case "Category":
            beliefs.sort { $0.category.lowercased() < $1.category.lowercased() }
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
