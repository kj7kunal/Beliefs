import SwiftUI

struct NewBeliefView: View {
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
            .navigationBarTitle("New Belief", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                saveBelief()
            })
        }
    }
    
    private func saveBelief() {
        DatabaseManager.shared.insertBelief(title: title, evidence: evidence)
        title = ""
        evidence = ""
    }
}

struct NewBeliefView_Previews: PreviewProvider {
    static var previews: some View {
        NewBeliefView()
    }
}
