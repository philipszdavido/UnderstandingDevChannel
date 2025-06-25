//
//  HomeUIView.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/4/24.
//

import SwiftUI

struct HomeUIView: View {
    
    @Environment(\.managedObjectContext) private var context;
    
    @FetchRequest(sortDescriptors:[])
    private var videos: FetchedResults<SearchListResponseEntity>

    @FetchRequest(sortDescriptors:[])
    private var videoInfo: FetchedResults<SearchListResponseInfoEntity>
    
    @State var loading = false
    
    @State var selectedFilter: VideoFilterType = .all
    @State private var prevSearchText = ""
        
    var body: some View {
        
        NavigationStack {
            
            MainHeaderView(
                searchAction: searchAction,
                cancelSearchAction: cancelSearchAction
            )
            
            HStack {
                
                FilterButton(
                    buttonText: "All",
                    selectedFilter: selectedFilter
                ) {
                    selectedFilter = .all
                    filterButtonAction()
                }
                
                FilterButton(
                    buttonText:"Popular",
                    selectedFilter: selectedFilter
                ) {
                    selectedFilter = .popular
                    filterButtonAction()
                }
                
                FilterButton(
                    buttonText:"Most Liked",
                    selectedFilter: selectedFilter
                ) {
                    selectedFilter = .mostLiked
                    filterButtonAction()
                }
                
                Spacer()
                
            }
            .padding(.leading)
            
            List {
                
                ForEach(videos, id: \.self) { video in
                    
                    ZStack {
                        
                        VideoItemUIView(videoItem: video)
                        
                        NavigationLink {
                            YoutubeVideoPlayUIView(videoId: video.id!)
                        } label: {
                            EmptyView()
                        }

                    }.onAppear(perform: {})
                    
                }

                HStack(alignment: .center) {
                    Spacer()
                    if let show = videoInfo.first {
                        if (show.nextPageToken != nil) {
                            Button("Load More") {
                                
                                loading = true;
                                
                                let first = videoInfo.first;
                                
                                if let first = first {
                                    
                                    // print(first.nextPageToken)
                                    
                                    do {
                                        
                                        try YoutubeHttp
                                            .loadVideosNextPage(
                                                context,
                                                filter: selectedFilter
                                            )
                                        
                                        loading = false
                                        
                                    } catch {
                                        
                                        loading = false
                                        
                                    }
                                    
                                }
                                
                            }.foregroundColor(.blue)
                            .disabled(loading == true).overlay {
                                if loading {
                                    ProgressView()
                                }
                            }
                                
                        }
                    }
                    Spacer()
                }
                .listSectionSeparator(.hidden, edges: .all)

            }.listStyle(.plain)
                
            

        }
    }
    
    private func filterButtonAction() {
        
        let filter: VideoFilterType = selectedFilter
        
        loading = true
        
        clearAllVideoResourceEntityData(context)
        clearAllVideoInfoEntityData(context)
        
        do {

            try YoutubeHttp
                .loadVideosWithFilter(in: context, filter: filter)
            
            loading = false
            
        } catch {
            loading = false
            print(error)
        }

    }

    func searchAction(searchText: Any) {
        print(searchText)
        loading = true;
        prevSearchText = searchText as! String
        
        clearAllVideoResourceEntityData(context)
        clearAllVideoInfoEntityData(context)

        do {
            try YoutubeHttp
                .loadVideosWithFilter(
                    in: context,
                    q: searchText as? String,
                    filter: selectedFilter
                )

            loading = false

        } catch {
            loading = false
            print(error)
        }
    }
    
    func cancelSearchAction() {
        
        if prevSearchText.isEmpty {
            return
        }
        
        do {
            
            try YoutubeHttp
                .loadVideosWithFilter(
                    in: context,
                    pageToken: nil,
                    filter: selectedFilter
                )
            
            prevSearchText = ""
            
        } catch {
            
        }
    }
    
}

struct HomeUIView_Previews: PreviewProvider {
    static var previews: some View {
        let response = generateMockVideoResourceResponse()
        let context = PersistenceController.preview.container.viewContext
        let videoInfoEntity = SearchListResponseInfoEntity(context: context)
        
        if response.nextPageToken != nil {
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

        return HomeUIView().environment(\.managedObjectContext, context)
    }
}
#Preview {
    HomeUIView_Previews.previews
}
