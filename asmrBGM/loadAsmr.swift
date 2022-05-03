//
//  loadAsmr.swift
//  asmrBGM
//
//  Created by natha on 5/2/22.
//

import SwiftUI
import AVKit
import MediaPlayer
import Foundation
import Combine

struct Track: Identifiable {
    
    let id = UUID()
    let item: MPMediaItem
    let title: String
    let assetURL: URL?
    let artist: String
    
    init(item: MPMediaItem) {
        self.item = item
        self.title = item.title ?? "No Title"
        self.artist = item.artist ?? "No Artist"
        if let url = item.assetURL {
            self.assetURL = url
        } else {
            self.assetURL = nil
        }
    }
    
    static func TrackList() -> [Track] {
        let list = MPMediaQuery.songs().items ?? []
        var tracklist: [Track]  = []
        for item in list {
            tracklist.append(Track(item: item))
        }
        return tracklist
    }
}

struct loadAsmr: View {
    @Binding var asmrURL: String
    @EnvironmentObject var localaudio: localAudio
    var tracklist = Track.TrackList()
    var body: some View {
        List(tracklist) {audio in
            Text(audio.title).onTapGesture {
                asmrURL = audio.assetURL!.absoluteString
                print("Song changed to \(asmrURL).")
            }
        }
    }
}

struct loadAsmr_Previews: PreviewProvider {
    static var previews: some View {
        loadAsmr(asmrURL: .constant(""))
    }
}
