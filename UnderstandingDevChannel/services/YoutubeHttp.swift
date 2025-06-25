//
//  YoutubeHttp.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/4/24.
//

import Foundation
import CoreData

struct ResourceId: Codable {
    var videoId: String;
}

struct PlayListSnippet: Codable {
    var resourceId: ResourceId
    var channelTitle: String;
    var publishedAt: String;
    var channelId: String;
    var title: String;
    var description: String;
    var thumbnails: Thumbnails
}

struct PlayListResource: Codable, Identifiable {
    var id: String;
    var snippet: PlayListSnippet;
}

struct PlayList: Codable {
    
    var items: [PlayListResource]
    
}

class YoutubeHttp {
    
    let channelId = "UCUCHv7YOQXWy2dsL-0IrlPw"
    let mine = "true"
    
    let playLists = [
        "PLMzqoOUCrwIZ-RCKL9nYzyIWyD6YTbCvi", // Angular
        "PLMzqoOUCrwIZYDEDqDI0fsRIOFMLiJhvH", // SwiftUI
        "PLMzqoOUCrwIaXLaoYOZtSepLDTp0Tgldq", // Java
        "PLMzqoOUCrwIb_hK5AksIqgVsx4I1PSgE2" // Understanding JavaScript
    ]
    
    let key = googleAPIKey
    
    static let shared = YoutubeHttp()
    
    func asynclistMyPlayList(pageToken nextPageToken: String? = nil, completionHandler: (_ data: (PlaylistResourceResponse?, NSError?)) -> Void) async throws {
        
        let part = "snippet,contentDetails,player"
        
        guard let baseURL = URL(string: "https://www.googleapis.com/youtube/v3/playlists") else {
            throw NSError(domain: "listMyPlayList", code: 0, userInfo: nil)
        }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        var queryItems = [
            URLQueryItem(name: "channelId", value: self.channelId),
            URLQueryItem(name: "part", value: part),
            URLQueryItem(name: "key", value: self.key)
        ]
        
        if let nextPageToken = nextPageToken {
            queryItems.append(URLQueryItem(name: "pageToken", value: nextPageToken))
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            throw NSError(domain: "listMyPlayList", code: 0, userInfo: nil)
        }
        
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        
        //print(url)
        
        do {
            
            let (data, _) = try await URLSession.shared.data(for: httpRequest)
            
            let decodedData = try JSONDecoder().decode(PlaylistResourceResponse.self, from: data)
            
            //print(decodedData)
            
            completionHandler((decodedData, nil))
            
        } catch {
            
            print(error)
            
            completionHandler((nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])))
            
        }
        
    }
    
    func listMyPlayList(pageToken nextPageToken: String? = nil, completionHandler: @escaping (_ data: (PlaylistResourceResponse?, NSError?)) -> Void) throws {
        
        let part = "snippet,contentDetails,player"
        
        guard let baseURL = URL(string: "https://www.googleapis.com/youtube/v3/playlists") else {
            throw NSError(domain: "listMyPlayList", code: 0, userInfo: nil)
        }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        var queryItems = [
            URLQueryItem(name: "channelId", value: self.channelId),
            URLQueryItem(name: "part", value: part),
            URLQueryItem(name: "key", value: self.key)
        ]
        
        if let nextPageToken = nextPageToken {
            queryItems.append(URLQueryItem(name: "pageToken", value: nextPageToken))
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            throw NSError(domain: "listMyPlayList", code: 0, userInfo: nil)
        }
        
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        
        //print(url)
        
        let dataTask =  URLSession.shared.dataTask(with: url) { data, _, error in
            
            do {
               
                if let data = data {

                    let decodedData = try JSONDecoder().decode(PlaylistResourceResponse.self, from: data)
                    
                    print(decodedData)
                    
                    completionHandler((decodedData, nil))
                    
                }
                
                if let error = error {
                    
                    completionHandler((nil, NSError(domain: "My Playlist", code: 0, userInfo: nil)))
                    
                    print(error)
                    
                }
                
            } catch {
                
                print(error)
                
                completionHandler((nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])))
                
            }
        }
        
        dataTask.resume()
        
    }
        
    private func searchVideos(
        pageToken nextPageToken: String? = nil,
        q: String? = nil,
        domainName: String,
        params: [String: String] = [:],
        type: SearchType,
        completionHandler: @escaping (_ data: (SearchListResponse?, NSError?)) -> Void
    ) throws {
        
        let part = "snippet"
        var searchType: String!
        
        switch type {
        case .video:
            searchType = "video"
            break
        case .channel:
            searchType = "channel"
            break
        case .playlist:
            searchType = "playlist"
            break
        default:
            searchType = "video"
            break
        }
        
        guard let baseUrl = URL(string: "https://www.googleapis.com/youtube/v3/search") else {
            throw NSError(domain: domainName, code: 0, userInfo: nil)
        }
        
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        
        var queryItems = [
            
            URLQueryItem(name: "part", value: part),
            URLQueryItem(name: "key", value: self.key),
            URLQueryItem(name: "type", value: searchType),
            URLQueryItem(name: "channelId", value: self.channelId),
            
        ]
        
        for param in params {
            queryItems.append(URLQueryItem(name: param.key, value: param.value))
        }
        
        if let nextPageToken = nextPageToken {
            queryItems.append(URLQueryItem(name: "pageToken", value: nextPageToken))
        }
        
        if let query = q {
            queryItems.append(URLQueryItem(name: "q", value: query))
        }
        
        urlComponents?.queryItems = queryItems;
        
        guard let url = urlComponents?.url else {
            
            throw NSError(domain: domainName, code: 0, userInfo: nil)
            
        }
        
        // print(url)
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            
            do {
                if let data = data {
                    
                    print(queryItems)
                    print(String(data: data, encoding: .utf8)!)
                    
                    let decodedData = try JSONDecoder().decode(SearchListResponse.self, from: data)
                    
                    print(decodedData)
                    
                    completionHandler((decodedData, nil))
                    
                    return;
                    
                }
                
                if let error = error {
                    
                    completionHandler(
                        (
                            nil,
                            NSError(domain: domainName, code: 0, userInfo: nil)
                        )
                    )
                    
                    print(error)
                    
                }
                
            } catch {
                
                completionHandler(
                    (nil, NSError(domain: domainName, code: 0, userInfo: nil))
                )
                
                print(error)
                
            }
            
        }
        
        dataTask.resume()

    }
        
    func getPlayListItems(id: String, completionHandler: @escaping (_ data: (PlayList?, NSError?)) -> Void) throws {
        
        let part = "snippet"
        
        guard let baseUrl = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems") else {
            throw NSError(domain: "getPlayListItems", code: 0, userInfo: nil)
        }
        
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        
        let queryItems = [
            URLQueryItem(name: "part", value: part),
            URLQueryItem(name: "key", value: self.key),
            URLQueryItem(name: "playlistId", value: id),
        ]
        
        urlComponents?.queryItems = queryItems;
        
        guard let url = urlComponents?.url else {
            
            throw NSError(domain: "", code: 0, userInfo: nil)
            
        }
        
        // print(url)
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            
            do {
                if let data = data {
                    
                    let decodedData = try JSONDecoder().decode(PlayList.self, from: data)
                    
                    completionHandler((decodedData, nil))
                    
                    return;
                    
                }
                
                if let error = error {
                    
                    print(error)
                    
                    completionHandler((nil, NSError(domain: "", code: 0, userInfo: nil)))
                    
                }
                
            } catch {
                print(error)
                completionHandler((nil, NSError(domain: "", code: 0, userInfo: nil)))
                
            }
            
        }
        
        dataTask.resume()
        
        
    }
    
    static func load(_ context: NSManagedObjectContext) async throws {
        
        let youtubeHttp = YoutubeHttp.shared
        
        let videoResourceEntityFetchRequest = SearchListResponseEntity.fetchRequest()
        let playlistResourceEntityFetchRequest = PlaylistResourceEntity.fetchRequest()
        
        do {
            clearAllPlaylistResourceEntityData(context)

            let playlist = try context.fetch(playlistResourceEntityFetchRequest)
            
            if playlist.isEmpty {
                
                clearAllPlaylistResourceEntityData(context)
                
                try youtubeHttp.listMyPlayList { data, error in
                    savePlaylistResourceResponse(data!, context: context)
                }
                
            }
            
            
            let videos = try context.fetch(videoResourceEntityFetchRequest)
            
            if videos.isEmpty {
                
                clearAllVideoResourceEntityData(context)
                
                try YoutubeHttp
                    .loadVideosWithFilter(
                        in: context,
                        pageToken: nil,
                        filter: .all
                    )
            }
            
        } catch {}
    }
    
    static func loadVideosWithFilter(
        in context: NSManagedObjectContext,
        pageToken nextPageToken: String? = nil,
        q: String? = nil,
        filter: VideoFilterType = .all
    ) throws {
        
        var params: [String: String] = [:]
        var domainName = ""
                
        switch filter {
        case .popular:
            params = ["order": "viewCount"]
            domainName = "Most Viewed Videos"
        case .mostLiked:
            params = ["order": "rating"]
            domainName = "Most Liked Videos"
        case .all:
            params = [:]
            domainName = "All Videos"
        }
        
        try YoutubeHttp.shared.searchVideos(
            pageToken: nextPageToken,
            q: q,
            domainName: domainName,
            params: params, type: SearchType.video
        ) { data, error in
            if let error = error {
                print("YouTube API request failed", error)
                return
            }

            guard let data = data else {
                print("YouTube API returned no data")
                return
            }

            do {
                try saveVideoResourceResponse(data, context: context)
            } catch {
                print("Failed to persist video data", error)
            }
        }
    }

    static func loadVideosNextPage(_ context: NSManagedObjectContext, filter: VideoFilterType = .all) throws {
                        
        // let fetchRequest = VideoResourceEntity.fetchRequest()
        let videoInfoEntityFetchRequest = SearchListResponseInfoEntity.fetchRequest()
        
        // get the MostPopuVideo info
        
        // if next token present
        // make call with it
        do {
            let mostPopu = try context.fetch(videoInfoEntityFetchRequest)
            
            if let first = mostPopu.first, let nextPageToken = first.nextPageToken {
                try YoutubeHttp
                    .loadVideosWithFilter(
                        in: context,
                        pageToken: nextPageToken,
                        filter: filter
                    )
            }
            
            try context.save()
            
        } catch {
            print("loadMostPopularVideosNextPage \(error)")
        }
        
    }

    static func loadPlaylistNextPage(_ context: NSManagedObjectContext) throws {
        let youtubeHttp = YoutubeHttp.shared

        let playlistResourceResponseEntityFetchRequest = PlaylistResourceResponseEntity.fetchRequest()

        // get the PlaylistResourceResponseEntity info
        
        // if next token present
        // make call with it
        do {
            let playlistInfos = try context.fetch(playlistResourceResponseEntityFetchRequest)
            
            if let first = playlistInfos.first, let nextPageToken = first.nextPageToken {
                try youtubeHttp.listMyPlayList(pageToken: nextPageToken) { data, error in
                    let itemsSet = NSMutableSet()
                    
                    if let data = data {
                        first.nextPageToken = data.nextPageToken
                        first.prevPageToken = data.prevPageToken
                        
                        for item in data.items {
                            let itemEntity = SearchListResponseEntity(
                                context: context
                            )
                            itemEntity.id = item.id
                            // itemEntity.id = item.id.videoId
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
                    }

                }
            }
            
            try context.save()

        } catch {
            print("loadMostPopularVideosNextPage \(error)")
        }
        
    }

}

func clearAllVideoInfoEntityData(_ context: NSManagedObjectContext) {
    let fetchRequest = SearchListResponseEntity.fetchRequest()
    
    do {
        let results = try context.fetch(fetchRequest)
        for object in results {
            context.delete(object)
        }
        try context.save()
    } catch {
        print("Error clearing data: \(error)")
    }
}

func clearAllVideoResourceEntityData(_ context: NSManagedObjectContext) {
    let fetchRequest = SearchListResponseEntity.fetchRequest()
    
    do {
        let results = try context.fetch(fetchRequest)
        for object in results {
            context.delete(object)
        }
        try context.save()
    } catch {
        print("Error clearing data: \(error)")
    }
}

func clearAllPlaylistResourceEntityData(_ context: NSManagedObjectContext) {
    let fetchRequest = PlaylistResourceEntity.fetchRequest()
    
    do {
        let results = try context.fetch(fetchRequest)
        for object in results {
            context.delete(object)
        }
        try context.save()
    } catch {
        print("Error clearing data: \(error)")
    }
}

