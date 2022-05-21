//
//  asmrAlbum.swift
//  asmrBGM
//
//  Created by natha on 5/18/22.
//

import SwiftUI
import AVKit
import MediaPlayer
import Foundation
import Combine

struct asmrAlbum: Identifiable, Equatable, Hashable, Codable, Comparable {

    let id: UUID
    var albumTitle: String
    var albumPersistentID: MPMediaEntityPersistentID
    var songs: [asmrTrack]

    init(songlist: [asmrTrack]) {
        albumTitle = songlist[0].albumTitle
        albumPersistentID = songlist[0].albumPersistentID!
        songs = songlist
        id = UUID()
    }

    static func AlbumList() -> [asmrAlbum] {
        let list = MPMediaQuery.albums().items ?? []
        if (list == []) {
            return []
        }
        var tracklist: [asmrTrack] = []
        var albumlist: [asmrAlbum] = []
        var albumPersistentID: MPMediaEntityPersistentID = list[0].albumPersistentID
        var item: asmrTrack
        for mpmediaitem in list {
            item = asmrTrack(mpmediaitem)
            if (item.albumPersistentID == albumPersistentID) {
                tracklist.append(item)
            } else {
                albumlist.append(asmrAlbum(songlist: tracklist))
                tracklist = [item]
                albumPersistentID = item.albumPersistentID!
            }
        }
        if (tracklist.count > 0) {
            albumlist.append(asmrAlbum(songlist: tracklist))
        }
        return albumlist
    }
    //infer album track number from arraya ordering
    static func < (lhs: asmrAlbum, rhs: asmrAlbum) -> Bool {
        return lhs.albumTitle < rhs.albumTitle
    }

}


