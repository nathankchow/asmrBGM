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
    
    @StateObject private var store = BgmTrackStore()
    @Binding var bgmtrack: bgmTrack
    @Environment(\.presentationMode) var presentationMode
    @State private var searchTextLoad = ""
    @State private var searchTextAdd = ""

    var tracklist = bgmTrack.TrackList()
    var body: some View {
        TabView{
            
            VStack{
                TextField(
                    "Search your library",
                    text: $searchTextLoad
                )
                    .padding()
                    .onAppear {
                        BgmTrackStore.load {result in
                            switch result {
                            case .failure(let error):
                                print(error)
                                store.bgmTracks = []
                            case .success (let bgmtracks):
                                store.bgmTracks = bgmtracks
                            }
                        }
                    }

                List {
                    ForEach(searchResultsLoad, id: \.self) {audio in
                            Text(audio.title).onTapGesture {
                                bgmtrack = audio
                                print("Song changed to \(audio.title).")
                                presentationMode.wrappedValue.dismiss()
                            }

                    }
                }
                Button(action: {
                    store.bgmTracks = []
                    BgmTrackStore.save(bgmtracks: store.bgmTracks) { result in
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
                    text: $searchTextAdd
                )
                    .padding()

                List {
                    ForEach(searchResultsAdd, id: \.self) {audio in
                            Text(audio.title).onTapGesture {
//                                asmrtrack = audio
//                                print("Song changed to \(audio.title).")
//                                presentationMode.wrappedValue.dismiss()
                                store.bgmTracks.append(audio)
                                BgmTrackStore.save(bgmtracks: store.bgmTracks) { result in
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

    var subtractedAddList: [bgmTrack] {
        return bgmTrack.filteredList(original: tracklist, filter: store.bgmTracks)
    }
    
    
    var searchResultsLoad: [bgmTrack] {
        if searchTextLoad.isEmpty {
            return store.bgmTracks
        } else {
            return store.bgmTracks.filter {$0.title.lowercased().contains(searchTextLoad.lowercased())}
        }
    }
    
    var searchResultsAdd: [bgmTrack] {
        if searchTextAdd.isEmpty {
            return subtractedAddList
        } else {
            return subtractedAddList.filter {$0.title.lowercased().contains(searchTextAdd.lowercased())}
        }
    }
}

struct loadBgm_Previews: PreviewProvider {
    static var previews: some View {
        loadBgm(bgmtrack: .constant(bgmTrack(nil)))
    }
}
