//
//  loadAlbum.swift
//  asmrBGM
//
//  Created by natha on 5/18/22.
//
import SwiftUI
import AVKit
import MediaPlayer
import Foundation
import Combine

//note not all albums have numbers attached to them
//use albumpersistentid as ground truth for identifying album groupings
//dont forget to consider a case where only half of the tracks are labeled with an album 

struct loadAlbum: View, Equatable {
    static func == (lhs: loadAlbum, rhs: loadAlbum) -> Bool {
        return true
    }
    
    @StateObject private var store = AsmrAlbumStore()
    @Environment(\.presentationMode) var presentationMode
    @Binding var asmralbum: asmrAlbum
    @State private var searchTextLoad = ""
    @State private var searchTextAdd = ""
    
    var albumlist = asmrAlbum.AlbumList()

    var body: some View {
        TabView {
            VStack{
                TextField(
                    "Search your library",
                    text: $searchTextLoad
                )
                    .padding()
                    .onAppear {
                        AsmrAlbumStore.load {result in
                            switch result {
                            case .failure (let error):
                                print(error.localizedDescription)
                                store.asmrAlbums = []
                            
                            case .success (let asmralbums):
                            store.asmrAlbums = asmralbums
                            }
                        }
                    }
                List {
                    ForEach(searchResultsLoad, id: \.self) {album in
                        HStack{
                            Text(album.albumTitle)
                            Spacer()
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                asmralbum = album
                                presentationMode.wrappedValue.dismiss()
                            }
                        ForEach(album.songs, id: \.self) {song in
                            Text("\(song.title)").padding(.leading)
                        }
                        
                    }
                }
                
                Button(action: {
                    store.asmrAlbums = []
                    save()
                }) {
                    Text("CLEAR ALL ALBUMS")
                }
            }.tabItem {
                Image(systemName: "play.circle")
                Text("Load")
            }
            
            VStack {
                TextField(
                    "Search your library",
                    text: $searchTextAdd
                )
                    .padding()
                List {
                    ForEach(searchResultsAdd, id: \.self) {album in
                        Text(album.albumTitle).onTapGesture {
                            store.asmrAlbums.append(album)
                            save()
                        }
                        ForEach(album.songs, id: \.self) {song in
                            Text("\(song.title)").padding(.leading)
                        }
                        
                    }
                }
            }.tabItem {
                Image(systemName: "pause.circle")
                Text("Add")
            }
        }
//        let songs = MPMediaQuery.albums().items ?? []
//        Text("This page is for albumns").onAppear{
//            print("Gonna print some songs")
//            print(songs.count)
//            for song in songs {
//                print("\(song.albumTitle ?? "No Album"),\(song.title ?? "No Title"),track number: \(song.albumTrackNumber), album id = \(song.albumPersistentID) ")
//
//            }
//        }
        let albums = asmrAlbum.AlbumList()
    }
    var subtractedAddList: [asmrAlbum] {
        return albumlist
    }
    
    var searchResultsLoad: [asmrAlbum] {
        if searchTextLoad.isEmpty {
            return store.asmrAlbums
        } else {
            return []
        }
    }
    
    var searchResultsAdd: [asmrAlbum] = asmrAlbum.AlbumList()
    
    func save() {
        AsmrAlbumStore.save(asmralbums: store.asmrAlbums) {result in
            if case .failure (let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
}

struct loadAlbum_Previews: PreviewProvider {
    static var previews: some View {
        loadAlbum(asmralbum: .constant(asmrAlbum([])))
    }
}



//List {
//    ForEach(albums, id: \.self) {album in
//        Text("\(album.albumTitle)").onTapGesture {
//            asmralbum = album
//                print("Song changed to \(album.albumTitle).")
//            presentationMode.wrappedValue.dismiss()
//            }
//        ForEach(album.songs, id: \.self) { song in
//            Text("\(song.title)").padding(.leading)
//        }
//
//    }
//}
