//
//  YoutubeVideoPlayUIView.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/7/24.
//

import SwiftUI
import WebKit

struct YoutubeVideoPlayUIView: View {
    
    let videoId: String

    var body: some View {
        YouTubeView(videoId: self.videoId)
    }
}

#Preview {
    YoutubeVideoPlayUIView(videoId: "ivPP836tE4M")
}


struct YouTubeView: UIViewRepresentable {
    let videoId: String
    func makeUIView(context: Context) ->  WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let demoURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: demoURL))
    }
}
