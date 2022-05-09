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

struct loadAsmr: View, Equatable {
    static func == (lhs: loadAsmr, rhs: loadAsmr) -> Bool {
        return lhs.tracklist == rhs.tracklist
    }
    
    @Binding var asmrtrack: asmrTrack
    @Environment(\.presentationMode) var presentationMode

    var tracklist = asmrTrack.TrackList()
    var body: some View {
        List(tracklist) {audio in
            Text(audio.title).onTapGesture {
                asmrtrack = audio
                print("Song changed to \(audio.title).")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

}

struct loadAsmr_Previews: PreviewProvider {
    static var previews: some View {
        loadAsmr(asmrtrack: .constant(asmrTrack(nil)))
    }
}
