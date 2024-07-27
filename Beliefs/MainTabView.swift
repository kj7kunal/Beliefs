//
//  MainTabView.swift
//  Beliefs
//
//  Created by kunal.jain on 2024/07/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "list.bullet")
                }
            
            BeliefsView()
                .tabItem {
                    Label("My Beliefs", systemImage: "book.fill")
                }
            
            NewBeliefView()
                .tabItem {
                    Label("New Belief", systemImage: "plus.circle.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
