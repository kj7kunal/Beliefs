import SwiftUI

struct NewBeliefView: View {
    @State private var title: String = ""
    @State private var evidence: String = ""
    @State private var categories: [Category] = []
    @State private var selectedCategory = "Misc"
    @State private var categoryInput = ""
    @Environment(\.presentationMode) var presentationMode
    
    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Belief")) {
                    TextField("Enter your belief", text: $title)
                        .accessibilityIdentifier("beliefTextField")
                }
                Section(header: Text("Evidence")) {
                    TextField("Enter supporting evidence", text: $evidence)
                        .accessibilityIdentifier("evidenceTextField")
                }
                Section(header: Text("Category")) {
                    AutocompleteTextField(text: $categoryInput, suggestions: categories.map { $0.name }) { suggestion in
                        categoryInput = suggestion
                    }
                    .accessibilityIdentifier("categoryTextField")
                }
            }
            .navigationBarTitle("New Belief", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                saveBelief()
            })
        }
        .onAppear {
            categories = DatabaseManager.shared.fetchAllCategories()
            if categories.isEmpty {
                DatabaseManager.shared.insertCategory(name: "Misc")
                categories = DatabaseManager.shared.fetchAllCategories()
            }
        }
    }

    private func saveBelief() {
        guard !title.isEmpty else { return }
        let categoryToSave = categoryInput.isEmpty ? "Misc" : categoryInput
        if !categories.contains(where: { $0.name == categoryToSave }) {
            DatabaseManager.shared.insertCategory(name: categoryToSave)
        }
        DatabaseManager.shared.insertBelief(title: title, evidence: evidence, category: categoryToSave)
        title = ""
        evidence = ""
        categoryInput = ""
        presentationMode.wrappedValue.dismiss()
        onSave()
    }
}

struct NewBeliefView_Previews: PreviewProvider {
    static var previews: some View {
        NewBeliefView(onSave: {})
    }
}
