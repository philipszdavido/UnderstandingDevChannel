//
//  UnderstandingDevChannelApp.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/3/24.
//

import SwiftUI

@main
struct UnderstandingDevChannelApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var globalSettings = GlobalSettings.shared
        
    var body: some Scene {
        WindowGroup {
            
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(globalSettings)
                    .preferredColorScheme(globalSettings.selectedScheme.colorScheme)

        }
    }
}
