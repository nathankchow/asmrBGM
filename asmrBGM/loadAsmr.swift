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
        return true
    }
    
    @Binding var asmrtrack: asmrTrack
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""

    var tracklist = asmrTrack.TrackList()
    var body: some View {
        TextField(
            "Search your library",
            text: $searchText
        )
            .padding()

        List {
            ForEach(searchResults, id: \.self) {audio in
                    Text(audio.title).onTapGesture {
                        asmrtrack = audio
                        print("Song changed to \(audio.title).")
                        presentationMode.wrappedValue.dismiss()
                    }
                
            }
        }
    }
    
    var searchResults: [asmrTrack] {
        if searchText.isEmpty {
            return tracklist
        } else {
            return tracklist.filter {$0.title.lowercased().contains(searchText.lowercased())}
        }
    }
}

struct loadAsmr_Previews: PreviewProvider {
    static var previews: some View {
        loadAsmr(asmrtrack: .constant(asmrTrack(nil)))
    }
}
