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

struct asmrTrack: Identifiable, Equatable {
    
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

    static func TrackList() -> [asmrTrack] {
        let list = MPMediaQuery.songs().items ?? []
        var tracklist: [asmrTrack]  = []
        for item in list {
            tracklist.append(asmrTrack(item))
        }
        tracklist.append(asmrTrack(nil))
        return tracklist
    }
}


