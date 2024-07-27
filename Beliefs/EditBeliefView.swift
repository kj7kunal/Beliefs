import SwiftUI

struct EditBeliefView: View {
    @Binding var belief: Belief?
    var onUpdate: () -> Void
    
    @State private var title: String = ""
    @State private var evidence: String = ""
    @Environment(\.presentationMode) var presentationMode  // To control the view presentation
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Belief")) {
                    TextField("Enter your belief", text: $title)
                }
                Section(header: Text("Evidence")) {
                    TextField("Enter supporting evidence", text: $evidence)
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
            }
        }
    }
    
    private func saveBelief() {
        guard var belief = belief else { return }
        // Update the local belief data
        belief.title = title
        belief.evidence = evidence
        // Update the database
        DatabaseManager.shared.updateBelief(id: belief.id, title: title, evidence: evidence)
        // Notify the parent view of the update
        onUpdate()
        presentationMode.wrappedValue.dismiss()  // Dismiss the view
    }
}

struct EditBeliefView_Previews: PreviewProvider {
    static var previews: some View {
        EditBeliefView(belief: .constant(Belief(id: 0, title: "Sample Belief", evidence: "Sample Evidence")), onUpdate: {})
    }
}
