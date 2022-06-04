//
//  loadBoth.swift
//  asmrBGM
//
//  Created by natha on 6/3/22.
//

import SwiftUI

struct loadBoth: View, Equatable {
    static func == (lhs: loadBoth, rhs: loadBoth) -> Bool {
        return true
    }
    
    @Binding var asmralbum: asmrAlbum
    @Binding var asmrtrack: asmrTrack
    @State private var searchTextLoad = ""
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var trackstore = AsmrTrackStore()
    @ObservedObject private var albumstore = AsmrAlbumStore()
    var both: [asmrEither] {
        var either: [asmrEither] = []
        for track in trackstore.asmrTracks {
            either.append(asmrEither(track))
        }
        for album in albumstore.asmrAlbums {
            either.append(asmrEither(album))
        }
        either.sort()
        return either
    }
    
    var body: some View {
        VStack{
            List{
                ForEach(both, id: \.self) {item in
                    switch (item.type) {
                    case (.track):
                        HStack{
                            Text(item.title)
                            Spacer()
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                asmrtrack = item.track!
                            print("Song changed to \(item.title).")
                            presentationMode.wrappedValue.dismiss()
                        }
                    case (.album):
                        HStack{
                            Text(item.album!.albumTitle)
                            Spacer()
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                asmralbum = item.album!
                                presentationMode.wrappedValue.dismiss()
                            }
                        ForEach(item.album!.songs, id: \.self) {song in
                            Text("\(song.title)").padding(.leading)
                        }
                    default:
                        Text("Nothing")
                    }
                }
            }
            Button(action: debug) {
                Text("debug")
            }
        }.onAppear {
            AsmrTrackStore.load {result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    trackstore.asmrTracks = []
                    //fatalError(error.localizedDescription)
                case .success (let asmrtracks):
                    trackstore.asmrTracks = asmrtracks
                }
            }
            AsmrAlbumStore.load {result in
                switch result {
                case .failure (let error):
                    print(error.localizedDescription)
                    albumstore.asmrAlbums = []
                
                case .success (let asmralbums):
                albumstore.asmrAlbums = asmralbums
                }
            }
        }
    }
    func debug() {
        print(both.count)
    }
}

struct loadBoth_Previews: PreviewProvider {
    static var previews: some View {
        loadBoth(
            asmralbum: .constant(asmrAlbum([])),
            asmrtrack: .constant(asmrTrack(nil))
        )
    }
}
