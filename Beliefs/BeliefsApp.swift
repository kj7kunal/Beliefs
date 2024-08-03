//
//  BeliefsApp.swift
//  Beliefs
//
//  Created by kunal.jain on 2024/07/26.
//

import SwiftUI

@main
struct BeliefsApp: App {
    @StateObject private var userPreferences = UserPreferences()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(userPreferences)
                .preferredColorScheme(userPreferences.isDarkMode ? .dark : .light)
        }
    }
}
