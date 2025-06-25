//
//  Welcome.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/3/24.
//

import SwiftUI

struct Welcome: View {
    
    @EnvironmentObject private var globalSettings: GlobalSettings
    
    var body: some View {
        VStack {
            Image("youtube")
            Text("Understanding Dev Channel").font(.title).fontWeight(.bold).multilineTextAlignment(.center)
            
        }.onAppear(perform: {
            
            Timer.scheduledTimer(withTimeInterval: 90, repeats: false) { timer in
                print("bhng")
                globalSettings.firstLaunch = false
            }
            
        })
    }
}

#Preview {
    Welcome()
        .environmentObject(GlobalSettings.shared)
}
