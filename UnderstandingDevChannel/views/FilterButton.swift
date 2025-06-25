//
//  FilterButton.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 10/06/2025.
//

import SwiftUI

struct FilterButton: View {
    
    public var buttonText: String = ""
    public var selectedFilter: VideoFilterType
    public var action: @MainActor () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var isSelected: Bool {
        switch selectedFilter {
        case .all:
            return buttonText == "All"
        case .popular:
            return buttonText == "Popular"
        case .mostLiked:
            return buttonText == "Most Liked"
        default:
            return false
        }
    }
    
    var fillColor: Color {
        if isSelected {
            return Color.gray.opacity(0.9)
        }
        
        return Color.gray.opacity(0.5)
    }
    
    var body: some View {
        
        Button((buttonText)) {
            action()
        }
        .padding(9)
        .background(
            RoundedRectangle(
                cornerRadius: 8,
                style: .continuous
            )
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            .fill(fillColor)
            
        )
        .foregroundColor(colorScheme == .dark ? .white : .black)
        
    }
    
    init(
        buttonText: String,
        selectedFilter: VideoFilterType,
        action: @escaping @MainActor () -> Void
    ) {
        self.buttonText = buttonText
        self.selectedFilter = selectedFilter
        self.action = action
    }
}

#Preview {
    FilterButton(buttonText: "All", selectedFilter: .all, action: {})
    FilterButton(buttonText: "Popular", selectedFilter: .mostLiked, action: {})
    FilterButton(buttonText: "Most Liked", selectedFilter: .all, action: {})
}
