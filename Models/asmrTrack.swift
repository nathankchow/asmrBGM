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

struct asmrTrack: Identifiable, Equatable, Hashable, Codable, Comparable {
    
    let id: UUID
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
        id = UUID()
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
    
    static func < (lhs: asmrTrack, rhs: asmrTrack) -> Bool {
        return lhs.title < rhs.title
    }
    
    static func filteredList(original: [asmrTrack], filter: [asmrTrack]) -> [asmrTrack] {
        //create hashmap from filter
        var dict: [String] = []
        for track in filter {
            dict.append(track.assetURL?.absoluteString ?? "No Title")
        }
        //initialize empty array, then populate with entries from original array provided that the asseturl isn't found in hashmap
        var filtered: [asmrTrack] = []
        for track in original {
            if (!dict.contains(track.assetURL?.absoluteString ?? "No Title")) {
                filtered.append(track)
            }
        }
        return filtered
    }
}


