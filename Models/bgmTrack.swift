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

struct bgmTrack: Identifiable, Equatable, Hashable, Codable, Comparable {
    
    let id: UUID
    var title: String
    var assetURL: URL?
    var artist: String
    var duration: TimeInterval
    
    init(_ mpmediaitem: MPMediaItem?) {
        self.id = UUID()
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
    
    static func < (lhs: bgmTrack, rhs: bgmTrack) -> Bool {
        return lhs.title < rhs.title
    }
    
    static func filteredList(original: [bgmTrack], filter: [bgmTrack]) -> [bgmTrack] {
        //create hashmap from filter
        var dict: [String] = []
        for track in filter {
            dict.append(track.assetURL?.absoluteString ?? "No Title")
        }
        //initialize empty array, then populate with entries from original array provided that the asseturl isn't found in hashmap
        var filtered: [bgmTrack] = []
        for track in original {
            if (!dict.contains(track.assetURL?.absoluteString ?? "No Title")) {
                filtered.append(track)
            }
        }
        return filtered
    }
}


