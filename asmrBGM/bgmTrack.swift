//
//  bgmTrack.swift
//  bgmBGM
//
//  Created by natha on 5/5/22.
//

import SwiftUI
import AVKit
import MediaPlayer
import Foundation
import Combine

struct bgmTrack: Identifiable, Equatable, Hashable {
    
    let id = UUID()
    var title: String
    var assetURL: URL?
    var artist: String
    var duration: TimeInterval
    
    init(_ mpmediaitem: MPMediaItem?) {
        if let item = mpmediaitem {
            title = item.title ?? "No Title"
            assetURL = item.assetURL
            artist = item.artist ?? ""
            duration = item.playbackDuration
        } else {
            title = "No Title"
            assetURL = nil
            artist = "---"
            duration = TimeInterval(0.0)
        }
    }

    static func TrackList() -> [bgmTrack] {
        let list = MPMediaQuery.songs().items ?? []
        var tracklist: [bgmTrack]  = []
        for item in list {
            tracklist.append(bgmTrack(item))
        }
        tracklist.append(bgmTrack(nil))
        return tracklist
    }
}


