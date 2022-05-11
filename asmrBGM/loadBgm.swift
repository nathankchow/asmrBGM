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

struct loadBgm: View, Equatable {
    static func == (lhs: loadBgm, rhs: loadBgm) -> Bool {
        return true 
    }
    
    @Binding var bgmtrack: bgmTrack
    @Environment(\.presentationMode) var presentationMode

    var tracklist = bgmTrack.TrackList()
    var body: some View {
        List(tracklist) {audio in
            Text(audio.title).onTapGesture {
                bgmtrack = audio
                print("BGM changed to \(audio.title).")
                presentationMode.wrappedValue.dismiss()
            }.padding()
        }
    }

}

struct loadBgm_Previews: PreviewProvider {
    static var previews: some View {
        loadBgm(bgmtrack: .constant(bgmTrack(nil)))
    }
}
