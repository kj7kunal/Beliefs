import SwiftUI

struct EditBeliefView: View {
    @Binding var belief: Belief?
    var onUpdate: () -> Void
    
    @State private var title: String = ""
    @State private var evidence: String = ""
    @State private var categories: [Category] = []
    @State private var selectedCategory = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Belief")) {
                    TextField("Enter your belief", text: $title)
                }
                Section(header: Text("Evidence")) {
                    TextField("Enter supporting evidence", text: $evidence)
                }
                Section(header: Text("Category")) {
                    Picker("", selection: $selectedCategory) {
                        ForEach(categories.map { $0.name }, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Belief", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                saveBelief()
            })
        }
        .onAppear {
            if let belief = belief {
                title = belief.title
                evidence = belief.evidence
                selectedCategory = belief.category
            }
            categories = DatabaseManager.shared.fetchAllCategories()
        }
    }
    
    private func saveBelief() {
        guard var belief = belief else { return }
        belief.title = title
        belief.evidence = evidence
        belief.category = selectedCategory
        DatabaseManager.shared.updateBelief(id: belief.id, title: title, evidence: evidence, category: belief.category)
        onUpdate()
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditBeliefView_Previews: PreviewProvider {
    static var previews: some View {
        EditBeliefView(belief: .constant(Belief(id: 0, title: "Sample Belief", evidence: "Sample Evidence", category: "Sample Category")), onUpdate: {})
    }
}
