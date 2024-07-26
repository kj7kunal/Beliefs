import SwiftUI

struct EditBeliefView: View {
    @Binding var belief: Belief?
    var onUpdate: () -> Void
    
    @State private var title: String = ""
    @State private var evidence: String = ""
    
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
                if let belief = belief {
                    DatabaseManager.shared.updateBelief(id: belief.id, title: title, evidence: evidence)
                    onUpdate()
                }
            })
        }
        .onAppear {
            if let belief = belief {
                title = belief.title
                evidence = belief.evidence
            }
        }
    }
}

struct EditBeliefView_Previews: PreviewProvider {
    static var previews: some View {
        EditBeliefView(belief: .constant(Belief(id: 0, title: "Sample Belief", evidence: "Sample Evidence")), onUpdate: {})
    }
}
