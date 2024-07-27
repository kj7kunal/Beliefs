import SwiftUI

struct BeliefsView: View {
    @State private var beliefs: [Belief] = []
    @State private var showEditView = false
    @State private var selectedBelief: Belief?

    var body: some View {
        NavigationView {
            List {
                ForEach(beliefs) { belief in
                    HStack {
                        Text(belief.title)
                        Spacer()
                        Button(action: {
                            selectedBelief = belief
                            showEditView.toggle()
                        }) {
                            Image(systemName: "pencil")
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("My Beliefs")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button("Refresh") {
                    refreshBeliefs()
                }
            )
            .sheet(isPresented: $showEditView) {
                if selectedBelief != nil {
                    EditBeliefView(belief: $selectedBelief, onUpdate: {
                        refreshBeliefs()
                    })
                }
            }
        }
        .onAppear {
            refreshBeliefs()
        }
    }
    
    private func refreshBeliefs() {
        beliefs = DatabaseManager.shared.fetchAllBeliefs()
        print("Fetched Beliefs: \(beliefs)")
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let belief = beliefs[index]
            DatabaseManager.shared.deleteBelief(id: belief.id)
        }
        refreshBeliefs()
    }
}

struct BeliefsView_Previews: PreviewProvider {
    static var previews: some View {
        BeliefsView()
    }
}
