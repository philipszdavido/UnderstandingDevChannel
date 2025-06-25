//
//  GlobalSettings.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/4/24.
//

import Foundation
import Combine
import SwiftUICore

enum AppColorScheme: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

class GlobalSettings: ObservableObject {
    
    static let shared = GlobalSettings()
    
    // list or grid
    
    @Published
    var firstLaunch: Bool {
        didSet {
            UserDefaults.standard.set(self.firstLaunch, forKey: "firstLaunch")
        }
    }
    
    @Published var selectedScheme: AppColorScheme = .system
    
    init() {
        self.firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
    }
    
    func loadSettings() {

        self.firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")

    }
}
