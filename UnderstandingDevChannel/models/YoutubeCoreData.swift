//
//  YoutubeCoreData.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/6/24.
//

import Foundation
import CoreData

/*
class PageInfoEntity: NSManagedObject {
    @NSManaged var totalResults: Int
    @NSManaged var resultsPerPage: Int
}

class HighEntity: NSManagedObject {
    @NSManaged var url: String
    @NSManaged var width: Int
    @NSManaged var height: Int
}

class ThumbnailsEntity: NSManagedObject {
    @NSManaged var high: HighEntity
}

class SnippetEntity: NSManagedObject {
    @NSManaged var channelTitle: String
    @NSManaged var publishedAt: String
    @NSManaged var channelId: String
    @NSManaged var title: String
    @NSManaged var descriptionInfo: String
    @NSManaged var thumbnails: ThumbnailsEntity
}

class ContentDetailsEntity: NSManagedObject {
    @NSManaged var itemCount: Int
}

class PlaylistResourceEntity: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var kind: String
    @NSManaged var snippet: SnippetEntity
    @NSManaged var contentDetails: ContentDetailsEntity
}

class PlaylistResourceResponseEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var nextPageToken: String
    @NSManaged var prevPageToken: String
    @NSManaged var pageInfo: PageInfoEntity
    @NSManaged var items: NSSet
}
*/

func savePlaylistResourceResponse(_ response: PlaylistResourceResponse, context: NSManagedObjectContext) {
    let responseEntity = PlaylistResourceResponseEntity(context: context)
    
    let pageInfoEntity = PageInfoEntity(context: context)
    pageInfoEntity.totalResults = response.pageInfo.totalResults
    pageInfoEntity.resultsPerPage = response.pageInfo.resultsPerPage
    pageInfoEntity.nextPageToken = response.nextPageToken
    pageInfoEntity.prevPageToken = response.prevPageToken
    responseEntity.pageInfo = pageInfoEntity
    
    let itemsSet = NSMutableSet()
    for item in response.items {
        let itemEntity = PlaylistResourceEntity(context: context)
        itemEntity.id = item.id
        itemEntity.kind = item.kind
        
        let snippetEntity = SnippetEntity(context: context)
        snippetEntity.channelTitle = item.snippet.channelTitle
        snippetEntity.publishedAt = item.snippet.publishedAt
        snippetEntity.channelId = item.snippet.channelId
        snippetEntity.title = item.snippet.title
        snippetEntity.descriptionInfo = item.snippet.description
        
        let thumbnailsEntity = ThumbnailsEntity(context: context)
        let highEntity = HighEntity(context: context)
        highEntity.url = item.snippet.thumbnails.high.url
        highEntity.width = item.snippet.thumbnails.high.width
        highEntity.height = item.snippet.thumbnails.high.height
        thumbnailsEntity.high = highEntity
        snippetEntity.thumbnails = thumbnailsEntity
        
        itemEntity.snippet = snippetEntity
        
        let contentDetailsEntity = ContentDetailsEntity(context: context)
        contentDetailsEntity.itemCount = item.contentDetails.itemCount
        itemEntity.contentDetails = contentDetailsEntity
        
        itemsSet.add(itemEntity)
    }
    responseEntity.items = itemsSet
    
    do {
        try context.save()
    } catch {
        print("Error saving managed object context: \(error)")
    }
}

func generateMockPlaylistResourceResponse() -> PlaylistResourceResponse {
    // Generate random token strings
    let nextPageToken = UUID().uuidString
    let prevPageToken = UUID().uuidString
    
    // Generate random page info
    let pageInfo = PageInfo(
        totalResults: Int64(Int.random(in: 1...10)),
                            
        resultsPerPage: Int64(Int.random(in: 1...5))
    )
    
    let ids = ["PLMzqoOUCrwIZYDEDqDI0fsRIOFMLiJhvH", "PLMzqoOUCrwIaXLaoYOZtSepLDTp0Tgldq", "PLMzqoOUCrwIZ-RCKL9nYzyIWyD6YTbCvi","PLMzqoOUCrwIb_hK5AksIqgVsx4I1PSgE2",]
    let thumbnails = ["https://i.ytimg.com/vi/50kn9k2ZzCo/hqdefault.jpg", "https://i.ytimg.com/vi/AAwpJncPZ34/hqdefault.jpg", "https://i.ytimg.com/vi/sETDZhuktCY/hqdefault.jpg", "https://i.ytimg.com/vi/MSiSSfFeRTo/hqdefault.jpg", "https://i.ytimg.com/vi/ufIJdOLEFsg/hqdefault.jpg", "https://i.ytimg.com/vi/VSa30P44fSg/hqdefault.jpg",]
    
    // Generate random playlist resources
    var items = [PlaylistResource]()
    for _ in 1...10 {
        let id = ids.shuffled().randomElement()!
        let kind = "video"
        let snippet = Snippet( channelTitle: "Channel \(Int.random(in: 1...100))",
                              publishedAt: Date().description,
                              channelId: UUID().uuidString,
                              title: "Video Title \(Int.random(in: 1...100))",
                               description: "Video Description \(Int.random(in: 1...100))",
                               thumbnails: Thumbnails( high: High(url: thumbnails[Int.random(in: 0...thumbnails.count - 1)], width: 100,height: 100)))
        let contentDetails = ContentDetails(itemCount: Int64(Int.random(in: 1...100)))
        let playlistResource = PlaylistResource(id: id, kind: kind, snippet: snippet, contentDetails: contentDetails)
        items.append(playlistResource)
    }
    
    return PlaylistResourceResponse(nextPageToken: nextPageToken,
                                     prevPageToken: prevPageToken,
                                     pageInfo: pageInfo,
                                     items: items)
}


func saveVideoResourceResponse(
    _ response: SearchListResponse,
    context: NSManagedObjectContext
) {
    
    let videoInfoEntity = SearchListResponseInfoEntity(context: context)
    
    if let nextPageToken = response.nextPageToken {
        videoInfoEntity.nextPageToken = response.nextPageToken
        videoInfoEntity.prevPageToken = response.prevPageToken
    }
    
    let itemsSet = NSMutableSet()
    for item in response.items {
        let itemEntity = SearchListResponseEntity(context: context)
        itemEntity.id = item.id.videoId
        itemEntity.kind = item.kind
        
        let snippetEntity = SnippetEntity(context: context)
        snippetEntity.channelTitle = item.snippet.channelTitle
        snippetEntity.publishedAt = item.snippet.publishedAt
        snippetEntity.channelId = item.snippet.channelId
        snippetEntity.title = item.snippet.title
        snippetEntity.descriptionInfo = item.snippet.description
        
        let thumbnailsEntity = ThumbnailsEntity(context: context)
        let highEntity = HighEntity(context: context)
        highEntity.url = item.snippet.thumbnails.high.url
        highEntity.width = item.snippet.thumbnails.high.width
        highEntity.height = item.snippet.thumbnails.high.height
        thumbnailsEntity.high = highEntity
        snippetEntity.thumbnails = thumbnailsEntity
        
        itemEntity.snippet = snippetEntity
                
        itemsSet.add(itemEntity)
    }
    
    do {
        try context.save()
    } catch {
        print("Error saving managed object context: \(error)")
    }
}


func generateMockVideoResourceResponse() -> SearchListResponse {
    // Generate random token strings
    let nextPageToken = UUID().uuidString
    let prevPageToken = UUID().uuidString
    
    // Generate random page info
    let pageInfo = PageInfo(
        totalResults: Int64(Int.random(in: 1...1000)),
        resultsPerPage: Int64(Int.random(in: 10...50))
    )
    
    let titles = ["Angular viewChild Signal Query: Complete Guide", "Understanding Public and Private Fields In JavaScript II: Privatise Static Properties", "Angular Signals: Basics", "Angular viewChild Signal Query: Complete Guide",]
    
    let thumbnails = ["https://i.ytimg.com/vi/AAwpJncPZ34/hqdefault.jpg", "https://i.ytimg.com/vi/sETDZhuktCY/hqdefault.jpg", "https://i.ytimg.com/vi/MSiSSfFeRTo/hqdefault.jpg", "https://i.ytimg.com/vi/ufIJdOLEFsg/hqdefault.jpg", "https://i.ytimg.com/vi/VSa30P44fSg/hqdefault.jpg",]
    
    var items = [SearchListItem]()
    for _ in 1...10 {
        let id = VideoId(kind: "youtube#video", videoId: "AAwpJncPZ34")
        let kind = "video"
        
        let shuffledTitle = titles.shuffled().randomElement()!
        let shuffledThumbnail = thumbnails.shuffled().randomElement()!
        
        let snippet = Snippet(
            channelTitle: "Channel \(Int.random(in: 1...100))",
            publishedAt: Date().description,
            channelId: UUID().uuidString,
            title: shuffledTitle,
            description: "Video Description \(Int.random(in: 1...100))",
            thumbnails: Thumbnails(
                high: High(
                    url: shuffledThumbnail,
                    width: 100,
                    height: 100
                )
            )
        )
        
        let videoResource = SearchListItem(id: id, kind: kind, snippet: snippet)
        
        items.append(videoResource)
    }
    
    return SearchListResponse(
        nextPageToken: nextPageToken,
        prevPageToken: prevPageToken,
        pageInfo: pageInfo,
        items: items
    )
}
