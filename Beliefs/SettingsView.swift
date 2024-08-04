import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @State private var showingAlert = false
    @State private var beliefCount: Int = 0
    @State private var categoryStats: [String: Int] = [:]
    @State private var isCategoryStatsExpanded = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $userPreferences.isDarkMode) {
                        Text("Dark Mode")
                    }
                }
                
                Section(header: Text("Statistics")) {
                    Text("Total Beliefs: \(beliefCount)")
                    DisclosureGroup("Category Statistics", isExpanded: $isCategoryStatsExpanded) {
                        ForEach(categoryStats.keys.sorted { $0 > $1 }, id: \.self) { category in
                            Text("\(category): \(categoryStats[category]!)")
                        }
                    }
                }
                
                Section(header: Text("Data")) {
                    Button("Clear All Data") {
                        showingAlert = true
                    }
                    .foregroundColor(.red)
                    
                    Button("Export Data") {
                        exportData()
                    }
                    
                    Button("Import Data") {
                        importData()
                    }
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
                        fetchStatistics()
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                fetchStatistics()
            }
        }
    }
    
    private func fetchStatistics() {
        beliefCount = DatabaseManager.shared.getTotalBeliefsCount()
        categoryStats = DatabaseManager.shared.getCategoryStatistics()
    }
    
    private func exportData() {
        // Implementation for exporting data to JSON file
    }
    
    private func importData() {
        // Implementation for importing data from JSON file
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(UserPreferences())
    }
}
