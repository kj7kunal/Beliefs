import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $userPreferences.isDarkMode) {
                        Text("Dark Mode")
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(UserPreferences())
    }
}
