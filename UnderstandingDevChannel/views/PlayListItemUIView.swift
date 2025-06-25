//
//  PlayListItemUIView.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/4/24.
//

import SwiftUI

struct PlayListItemUIView: View {
    
    var imageUrl: String
    var title: String;
    var noOfVideos: Int64
    var publishedAt: String
    
    var body: some View {
        VStack(alignment: .leading) {
            
            AsyncImage(url: URL(string: imageUrl)){ image in
                image.resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
            } placeholder: {
                Rectangle()
                    .fill(.gray)
                    .frame(height: 200)
                    .overlay {
                        ProgressView()
                    }
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.medium)
                    .padding(.bottom, 1)
                
                HStack {
                    Image(systemName: "play.square.stack.fill")
                    Text("\(noOfVideos) videos")
                    Text("•")
                    Text(formattedRelativeDate(from: publishedAt))
                }
            }
            
        }
    }
}

#Preview {
    PlayListItemUIView(
        imageUrl: "https://i.ytimg.com/vi/50kn9k2ZzCo/hqdefault.jpg",
        title: "SwiftUI",
        noOfVideos: 100,
        publishedAt: ""
    )
}
