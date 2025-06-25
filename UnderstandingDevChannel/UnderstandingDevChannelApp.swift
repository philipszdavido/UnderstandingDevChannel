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
    let globalSettings = GlobalSettings.shared
    @AppStorage("appearanceMode") var appearanceMode: AppearanceMode = .system

        
    var body: some Scene {
        WindowGroup {
            
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(globalSettings)
                    .preferredColorScheme(appearanceMode == .system ? nil : (appearanceMode == .dark ? .dark : .light))
                
        }
    }
}
