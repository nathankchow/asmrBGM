//
//  asmrTrack.swift
//  asmrBGM
//
//  Created by natha on 5/5/22.
//

import SwiftUI
import AVKit
import MediaPlayer
import Foundation
import Combine

class asmrTrack: Identifiable, ObservableObject {
    
    let id = UUID()
    @Published var item: MPMediaItem?
    @Published var title: String
    @Published var assetURL: URL?
    @Published var artist: String
    @Published var duration: TimeInterval
    
    init() {
            self.item = nil
            self.title = "none"
            self.artist = "none"
            self.duration = TimeInterval(0.0)
            self.assetURL = nil
        }
    
    func updateMainTrack(title: String, artist: String, duration: TimeInterval, assetURL: URL) {
        self.title = title
        self.artist = artist
        self.duration = duration
        self.assetURL = assetURL
    }

    
    class func TrackList() -> [asmrTrack] {
        let list = MPMediaQuery.songs().items ?? []
        var tracklist: [asmrTrack]  = []
        for item in list {
            let temp = asmrTrack()
            temp.title = item.title ?? "No Title"
            temp.assetURL = item.assetURL
            temp.duration = item.playbackDuration
            tracklist.append(temp)
        }
        tracklist.append(asmrTrack())
        return tracklist
    }
}
