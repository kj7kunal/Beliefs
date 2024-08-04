import SwiftUI

struct BeliefsView: View {
    @State private var beliefs: [Belief] = []
    @State private var showEditView = false
    @State private var selectedBelief: Belief?
    @State private var showNewBeliefView = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(beliefs) { belief in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(belief.title).font(.headline)
                                Spacer()
                                Button(action: {
                                    selectedBelief = belief
                                    showEditView.toggle()
                                }) {
                                    Image(systemName: "pencil")
                                }
                            }
                            Text(belief.evidence).font(.subheadline).foregroundColor(.gray)
                            Text(belief.category)
                                .padding(5)
                                .background(getColor(for: belief.category).opacity(0.5))
                                .cornerRadius(5)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("My Beliefs")
                .navigationBarItems(
                    trailing: Button("New Belief") {
                        showNewBeliefView.toggle()
                    }
                )
                .sheet(isPresented: $showEditView) {
                    if selectedBelief != nil {
                        EditBeliefView(belief: $selectedBelief, onUpdate: {
                            refreshBeliefs()
                        })
                    }
                }
                .sheet(isPresented: $showNewBeliefView) {
                    NewBeliefView(onSave: {
                        refreshBeliefs()
                    })
                }
                .onAppear {
                    refreshBeliefs()
                }
            }
        }
    }
    
    private func refreshBeliefs() {
        beliefs = DatabaseManager.shared.fetchAllBeliefs()
        beliefs.sort { $0.id > $1.id }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let belief = beliefs[index]
            DatabaseManager.shared.deleteBelief(id: belief.id)
        }
        refreshBeliefs()
    }
    
    private func getColor(for category: String) -> Color {
        let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow, .pink, .gray]
        let hashValue = abs(category.hashValue)
        return colors[hashValue % colors.count]
    }
}

struct BeliefsView_Previews: PreviewProvider {
    static var previews: some View {
        BeliefsView()
    }
}
