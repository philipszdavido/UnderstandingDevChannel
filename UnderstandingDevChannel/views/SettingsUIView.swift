//
//  SettingsUIView.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/10/24.
//

import SwiftUI

enum AppearanceMode: String {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}

struct SettingsUIView: View {
    
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system
    
    var body: some View {

        NavigationView {
            List {
                
                NavigationLink("Appearance Mode") {
                    AppearanceModeView()
                }
                Spacer()
                    .listSectionSeparator(.hidden)
                
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .navigationTitle("Settings")
        }
        
    }
}

struct AppearanceModeView: View {
    
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 20) {
                    Text("Appearance Mode")
                        .font(.headline)
                
                Toggle("Dark Mode", isOn: Binding<Bool>(
                    get: {
                        self.appearanceMode == .dark
                    },
                    set: { newValue in
                        self.appearanceMode = newValue ? .dark : .system
                    }
                ))
                
                Toggle("Light Mode", isOn: Binding<Bool>(
                    get: {
                        self.appearanceMode == .light
                    },
                    set: { newValue in
                        self.appearanceMode = newValue ? .light : .system
                    }
                ))
                
                Toggle("System Mode", isOn: Binding<Bool>(
                    get: {
                        self.appearanceMode == .system
                    },
                    set: { newValue in
                        self.appearanceMode = newValue ? .system : .dark
                    }
                ))
            }
            .padding()
            Spacer()
        }.listSectionSeparator(.hidden)

    }
}

struct SettingsUIView_Preview: View {

    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .dark

    var body: some View {
        SettingsUIView()
            
            .preferredColorScheme(appearanceMode == .system ? nil : (appearanceMode == .dark ? .dark : .light))

    }
}

#Preview {
    SettingsUIView_Preview()
}
