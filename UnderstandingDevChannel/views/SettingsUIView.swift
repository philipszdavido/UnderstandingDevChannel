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

struct _AppearanceModeView: View {
    @EnvironmentObject var settings: GlobalSettings

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 20) {
                Text("Appearance Mode")
                    .font(.headline)

                Picker("Appearance Mode", selection: $settings.selectedScheme) {
                    Text("System").tag(AppColorScheme.system)
                    Text("Light").tag(AppColorScheme.light)
                    Text("Dark").tag(AppColorScheme.dark)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            Spacer()
        }
        .listSectionSeparator(.hidden)
    }
}

struct AppearanceModeView: View {
    
    @EnvironmentObject var settings: GlobalSettings
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 20) {
                    Text("Appearance Mode")
                        .font(.headline)
                
                Toggle("Dark Mode", isOn: Binding(
                    get: { settings.selectedScheme == .dark },
                    set: { newValue in
                        if newValue { settings.selectedScheme = .dark }
                    }
                ))
                Toggle("Light Mode", isOn: Binding(
                    get: { settings.selectedScheme == .light },
                    set: { newValue in
                        if newValue { settings.selectedScheme = .light }
                    }
                ))
                Toggle("System Mode", isOn: Binding(
                    get: { settings.selectedScheme == .system },
                    set: { newValue in
                        if newValue { settings.selectedScheme = .system }
                    }
                ))
            }
            .padding()
            Spacer()
        }.listSectionSeparator(.hidden)

    }
}

struct SettingsUIView_Preview: View {

    @StateObject var settings = GlobalSettings()

    var body: some View {
        SettingsUIView()
            .environmentObject(settings)
            .preferredColorScheme(settings.selectedScheme.colorScheme)

    }
}

#Preview {
    SettingsUIView_Preview()
}
