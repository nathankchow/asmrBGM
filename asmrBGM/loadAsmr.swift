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
    
    @StateObject private var store = AsmrTrackStore()
    @Binding var asmrtrack: asmrTrack
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""

    var tracklist = asmrTrack.TrackList()
    var body: some View {
        TabView{
            
            VStack{
                TextField(
                    "Search your library",
                    text: $searchText
                )
                    .padding()
                    .onAppear {
                        AsmrTrackStore.load {result in
                            switch result {
                            case .failure(let error):
                                fatalError(error.localizedDescription)
                            case .success (let asmrtracks):
                                store.asmrTracks = asmrtracks
                            }
                        }
                    }

                List {
                    ForEach(store.asmrTracks, id: \.self) {audio in
                            Text(audio.title).onTapGesture {
                                asmrtrack = audio
                                print("Song changed to \(audio.title).")
                                presentationMode.wrappedValue.dismiss()
                            }

                    }
                }
                Button(action: {
                    store.asmrTracks = []
                    AsmrTrackStore.save(asmrtracks: store.asmrTracks) { result in
                        if case .failure (let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }) {
                    Text("DEBUG BUTTON!")
                }
            }.tabItem {
                Image(systemName: "play.circle")
                Text("Load")
            }
            
            VStack{
                TextField(
                    "Search your library",
                    text: $searchText
                )
                    .padding()

                List {
                    ForEach(searchResults, id: \.self) {audio in
                            Text(audio.title).onTapGesture {
//                                asmrtrack = audio
//                                print("Song changed to \(audio.title).")
//                                presentationMode.wrappedValue.dismiss()
                                store.asmrTracks.append(audio)
                                AsmrTrackStore.save(asmrtracks: store.asmrTracks) { result in
                                    if case .failure (let error) = result {
                                        fatalError(error.localizedDescription)
                                    }
                                }
                                print("\(audio.title) appended to store possibly?")
                            }
                        
                    }
                }
            }.tabItem{
                Image(systemName: "pause.circle")
                Text("Add")
            }
        }
    }

    var subtractedAddList: [asmrTrack] {
        let asmrset1 = Set(tracklist)
        let asmrset2 = Set(store.asmrTracks)
        return Array(asmrset1.subtracting(asmrset2).sorted())
    }
    
    var searchResults: [asmrTrack] {
        if searchText.isEmpty {
            return subtractedAddList
        } else {
            return subtractedAddList.filter {$0.title.lowercased().contains(searchText.lowercased())}
        }
    }
}

struct loadAsmr_Previews: PreviewProvider {
    static var previews: some View {
        loadAsmr(asmrtrack: .constant(asmrTrack(nil)))
    }
}
