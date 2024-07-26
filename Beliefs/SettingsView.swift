import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("This is the Settings view")
                .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

