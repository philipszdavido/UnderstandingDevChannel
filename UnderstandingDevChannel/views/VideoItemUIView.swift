//
//  VideoItemUIView.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/8/24.
//

import SwiftUI
import CoreData

struct VideoItemUIView: View {
    
    var videoItem: SearchListResponseEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            
            AsyncImage(url: URL(string: (videoItem.snippet?.thumbnails?.high?.url)!)){ image in
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
                VStack {
                    HStack {
                        Text((videoItem.snippet?.title)!)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    HStack {
                        if let channelTitle = videoItem.snippet?.channelTitle {
                            Text(channelTitle)
                                .font(.caption)
                                
                        }
                        
                        HStack(spacing: 4) {
                            Text("•")
                        }
                        
                        if let publishedAt = videoItem.snippet?.publishedAt {
                            Text(
                                formattedRelativeDate(from: publishedAt)
                            )
                            .font(.caption)
                        }
                        Spacer()
                        
                    }
                    .padding(.leading, 5.0)
                }
            }
        }
    }
}

struct VideoItemUIView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext

        // Create a sample VideoResourceEntity
        let video = SearchListResponseEntity(context: context)
        video.id = "123"
        video.kind = "youtube#videoListResponse"

        let snippetEntity = SnippetEntity(context: context)
        snippetEntity.channelTitle = "Understanding Dev"
        snippetEntity.publishedAt = "2024-01-20T15:14:57Z"
        snippetEntity.channelId = "item.snippet.channelId"
        snippetEntity.title = "Angular viewChild Signal Query: Complete Guide"
        snippetEntity.descriptionInfo = "item.snippet.description"
        
        let thumbnailsEntity = ThumbnailsEntity(context: context)
        let highEntity = HighEntity(context: context)
        highEntity.url = "https://i.ytimg.com/vi/AAwpJncPZ34/hqdefault.jpg"
        highEntity.width = 900
        highEntity.height = 400
        thumbnailsEntity.high = highEntity
        snippetEntity.thumbnails = thumbnailsEntity
        
        video.snippet = snippetEntity

        return VideoItemUIView(videoItem: video)
    }
}

#Preview {
    VideoItemUIView_Previews.previews
    VideoItemUIView_Previews.previews
}

