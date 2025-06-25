//
//  GlobalSettings.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/4/24.
//

import Foundation
import Combine

class GlobalSettings: ObservableObject {
    
    static let shared = GlobalSettings()
    
    // list or grid
    
    @Published
    var firstLaunch: Bool {
        didSet {
            UserDefaults.standard.set(self.firstLaunch, forKey: "firstLaunch")
        }
    }
    
    init() {
        self.firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
    }
    
    func loadSettings() {

        self.firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
        print(UserDefaults.standard.bool(forKey: "firstLaunch"))

    }
}
