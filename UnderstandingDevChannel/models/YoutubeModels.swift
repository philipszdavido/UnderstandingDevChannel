//
//  YoutubeModels.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/4/24.
//

import Foundation

struct PageInfo: Codable {
    var totalResults: Int64;
    var resultsPerPage: Int64;
}

struct High: Codable {
    var url: String;
    var width: Int64;
    var height: Int64;
}

struct Thumbnails: Codable {
    var high: High;
}

struct Snippet: Codable {
    var channelTitle: String;
    var publishedAt: String;
    var channelId: String;
    var title: String;
    var description: String;
    var thumbnails: Thumbnails
}

struct ContentDetails: Codable {
    var itemCount: Int64;
}

struct PlaylistResource: Codable {
    var id: String;
    var kind: String;
    var snippet: Snippet;
    var contentDetails: ContentDetails
}

struct PlaylistResourceResponse: Codable {
    var nextPageToken: String?;
    var prevPageToken: String?;
    var pageInfo: PageInfo;
    
    var items: [PlaylistResource]
    
}

/** Video  **/
 
struct VideoId: Codable {
    var kind: String
    var videoId: String
}

struct SearchListItem: Codable {
    var id: VideoId;
    var kind: String;
    var snippet: Snippet;
}

struct SearchListResponse: Codable {
    // var id = UUID()
    var nextPageToken: String?;
    var prevPageToken: String?;
    var pageInfo: PageInfo;
    // VideoResource
    var items: [SearchListItem]
}

/** PlayListItem */

struct PlayListItemContentDetails: Codable {
    var videoId: String;
}

struct PlayListItemResource: Codable {
    var id: String;
    var kind: String;
    var snippet: Snippet;
    var contentDetails: PlayListItemContentDetails
}

struct PlayListItem: Codable {
    var nextPageToken: String;
    var prevPageToken: String;
    var pageInfo: PageInfo;
    
    var items: [PlayListItemResource]

}

enum VideoFilterType: Int {
    
    /** Video Filters */
    case all = 0
    case popular = 1
    case mostLiked = 2
    
}

enum SearchType: Int {
    
    case playlist = 0
    case video = 1
    case channel = 2
}
