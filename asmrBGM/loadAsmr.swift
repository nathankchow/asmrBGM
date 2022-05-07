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

struct loadAsmr: View {
    @Binding var asmrtrack: asmrTrack

    var tracklist = asmrTrack.TrackList()
    var body: some View {
        List(tracklist) {audio in
            Text(audio.title).onTapGesture {
                asmrtrack.updateMainTrack(title: audio.title, artist: audio.artist, duration: audio.duration, assetURL: audio.assetURL!)
                print("Song changed to \(audio.title).")
            }
        }
    }

}

struct loadAsmr_Previews: PreviewProvider {
    static var previews: some View {
        loadAsmr(asmrtrack: .constant(asmrTrack()))
    }
}
