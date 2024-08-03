import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $userPreferences.isDarkMode) {
                        Text("Dark Mode")
                    }
                }
                
                Section(header: Text("Data")) {
                    Button("Clear All Data") {
                        showingAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Clear All Data"),
                    message: Text("Are you sure you want to clear all data? This action cannot be undone."),
                    primaryButton: .destructive(Text("Clear")) {
                        DatabaseManager.shared.clearAllBeliefs()
                        DatabaseManager.shared.clearAllCategories()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(UserPreferences())
    }
}
