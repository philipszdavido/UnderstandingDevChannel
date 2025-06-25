//
//  PlaylistVideosUIView.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/8/24.
//

import SwiftUI

struct PlaylistVideosUIView: View {
    
    var playlistId: String
    
    @State var playlist: PlayList?
    @State var loading = false
    @Environment(\.dismiss) private var dismiss
    
    let youtubeHttp = YoutubeHttp()
    
    private func loadPlaylist() {
        
        #if DEBUG
        // Simulated data for testing
        #else

        Task {
            
            if playlistId.isEmpty {
                return
            }
            
            loading = true
            
            try youtubeHttp.getPlayListItems(id: playlistId) { data, error in
                
                if let data = data {
                    playlist = data
                    loading = false
                }
                
                if let error = error {
                    print(error)
                    loading = false
                }
                                    
            }
        }
        
        #endif

    }
    
    var body: some View {
        if loading {
            ProgressView()
        }
        
        if (playlist == nil && !loading) {
            Spacer()
            Text("No videos in playlist")
            Button("Refresh") {
                loadPlaylist()
            }
        }
        
        List {

            if let items = playlist?.items {
                ForEach(items) { item in
                    ZStack{
                        VStack(alignment: .leading) {
                            
                            AsyncImage(url: URL(string: item.snippet.thumbnails.high.url)){ image in
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
                            
                            HStack(alignment: .center) {
                                Text(item.snippet.title)
                                    .fontDesign(.rounded)
                                    .fontWeight(.bold)
                            }
                        }
                        NavigationLink {
                            YoutubeVideoPlayUIView(videoId: item.snippet.resourceId.videoId)
                        } label: {
                            EmptyView()
                        }.opacity(0)

                    }
                }
            }
            
        }
        .listStyle(.plain)
        .onAppear {
            loadPlaylist()
        }
        .toolbar {
            ToolbarItem(id: "topBarLeading", placement: .navigation) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PlaylistVideosUIView(playlistId: "PLMzqoOUCrwIb_hK5AksIqgVsx4I1PSgE2")
    }
}
