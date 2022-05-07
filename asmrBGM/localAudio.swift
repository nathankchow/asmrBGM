//
//  localAudio.swift
//  asmrBGM
//
//  Created by natha on 5/5/22.
//

import SwiftUI
import AVKit
import MediaPlayer
import Foundation
import Combine

final class localAudio: ObservableObject {
    @Published var localAudioList: [MPMediaItem]? = MPMediaQuery.songs().items
    
    func refreshLocalAudioList() {
        self.localAudioList = MPMediaQuery.songs().items
    }
    
    func printLocalAudioList() {
        for song in self.localAudioList ?? [] {
            print(song.title ?? "No Title")
        }
    }
}
