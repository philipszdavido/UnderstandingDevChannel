//
//  MainTabView.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/3/24.
//

import SwiftUI

struct MainTabView: View {
    
    let youtubeHttp = YoutubeHttp.shared
    
    @Environment(\.managedObjectContext) private var viewContext

    @EnvironmentObject private var globalSettings: GlobalSettings;
    
    @State var loading = false

    var body: some View {

        if globalSettings.firstLaunch == true {
            
            Welcome()
                
        } else {
            
            if loading {
                ProgressView()
            }
            
            TabView {
                HomeUIView().tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }.tag(1)
                
                PlaylistUIView().tabItem {
                    VStack {
                        Image(systemName: "play.square.stack.fill")
                        Text("Playlist")
                    }
                    
                }.tag(2)
                
                SettingsUIView().tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }

                }.tag(3)
                
            }.onAppear(perform: {
                                    
                    Task {
                        do {
                            loading = true
                            try await YoutubeHttp.load(viewContext)
                            loading = false
                        } catch {
                            print(error)
                            loading = false
                        }
                        
                    }

            })
            
        }
    }
}

#Preview {

    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(GlobalSettings.shared)
}
