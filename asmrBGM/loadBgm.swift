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
    @State private var searchText = ""


    var tracklist = bgmTrack.TrackList()
    var body: some View {
        TextField(
            "Search your library",
            text: $searchText
        )
            .padding()

        List {
            ForEach(searchResults, id: \.self) {audio in
                    Text(audio.title).onTapGesture {
                        bgmtrack = audio
                        print("Song changed to \(audio.title).")
                        presentationMode.wrappedValue.dismiss()
                    }
                
            }
        }
    }
    var searchResults: [bgmTrack] {
        if searchText.isEmpty {
            return tracklist
        } else {
            return tracklist.filter {$0.title.lowercased().contains(searchText.lowercased())}
        }
    }
}

struct loadBgm_Previews: PreviewProvider {
    static var previews: some View {
        loadBgm(bgmtrack: .constant(bgmTrack(nil)))
    }
}
