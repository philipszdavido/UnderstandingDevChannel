//
//  PlaylistUIView.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/4/24.
//

import SwiftUI
import CoreData

struct PlaylistUIView: View {
    
    @Environment(\.managedObjectContext) private var managedObjectContext;
    
    @FetchRequest(sortDescriptors: [])
    private var results: FetchedResults<PlaylistResourceEntity>
    
    @FetchRequest(sortDescriptors: [])
    private var info: FetchedResults<PageInfoEntity>
    
    @State var selection: String?
    
    @State var showHeader = true
    @State var loading = false
    
    func searchPlaylist(searchText: Any) {
        print(searchText)
    }
        
    var body: some View {
        
        NavigationStack {
            MainHeaderView(searchAction: searchPlaylist)
            
            HStack {
                FilterButton(
                    buttonText: "Highest",
                    selectedFilter: VideoFilterType.all
                ) {
                    
                }
                FilterButton(
                    buttonText: "Lowest",
                    selectedFilter: VideoFilterType.all
                ) {
                    
                }
                Spacer()
            }.padding(.leading)
            
            List(selection: $selection) {
                ForEach(results, id: \.self) { result in
                    
                    ZStack {
                        if let snippet = result.snippet {
                            PlayListItemUIView(
                                imageUrl: snippet.thumbnails!.high!.url!,
                                title: snippet.title!,
                                noOfVideos: result.contentDetails!.itemCount,
                                publishedAt: snippet.publishedAt!
                            )
                        }
                        
                        NavigationLink( destination: NavigationStack { PlaylistVideosUIView(playlistId: result.id!).navigationBarBackButtonHidden(true)}) {
                            
                            EmptyView()
                        }.opacity(0)
                    }
                    
                }
                
                HStack(alignment: .center) {
                    Spacer()
                    if let show = info.first {
                        if (show.nextPageToken != nil) {
                            Button("Load More") {
                                
                                loading = true;
                                
                                let first = info.first;
                                
                                if let first = first {
                                    
                                    // print(first.nextPageToken)
                                    
                                    do {
                                        
                                        try YoutubeHttp.loadPlaylistNextPage(managedObjectContext)
                                        
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
}

struct PlaylistUIView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        clearAllPlaylistResourceEntityData(context);
        let response = generateMockPlaylistResourceResponse()

        let responseEntity = PlaylistResourceResponseEntity(context: context)

        let pageInfoEntity = PageInfoEntity(context: context)
        pageInfoEntity.totalResults = response.pageInfo.totalResults
        pageInfoEntity.resultsPerPage = response.pageInfo.resultsPerPage
        pageInfoEntity.nextPageToken = response.nextPageToken;
        pageInfoEntity.prevPageToken = response.prevPageToken;
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

        return PlaylistUIView().environment(\.managedObjectContext, context)
    }
}
#Preview {
    PlaylistUIView_Previews.previews
}
