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

struct loadBgm: View {
    @Binding var bgmtrack: bgmTrack

    var tracklist = bgmTrack.TrackList()
    var body: some View {
        List(tracklist) {audio in
            Text(audio.title).onTapGesture {
                bgmtrack.updateMainTrack(title: audio.title, artist: audio.artist, duration: audio.duration, assetURL: audio.assetURL!)
                print("bgm track changed to \(audio.title).")
            }
        }
    }

}

struct loadBgm_Previews: PreviewProvider {
    static var previews: some View {
        loadBgm(bgmtrack: .constant(bgmTrack()))
    }
}
