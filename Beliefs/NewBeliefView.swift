import SwiftUI

struct NewBeliefView: View {
    var body: some View {
        NavigationView {
            Text("This is the New Belief view")
                .navigationTitle("New Belief")
        }
    }
}

struct NewBeliefView_Previews: PreviewProvider {
    static var previews: some View {
        NewBeliefView()
    }
}

