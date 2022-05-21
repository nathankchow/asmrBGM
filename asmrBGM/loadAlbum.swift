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
    var body: some View {
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
        List {
            ForEach(albums, id: \.self) {album in
                Text("\(album.albumTitle)").onTapGesture {
                        print("Song changed to \(album.albumTitle).")
                    }
                ForEach(album.songs, id: \.self) { song in
                    Text("\(song.title)").padding(.leading)
                }

            }
        }
    }
}

struct loadAlbum_Previews: PreviewProvider {
    static var previews: some View {
        loadAlbum()
    }
}
