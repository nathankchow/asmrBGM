//
//  asmrEither.swift
//  asmrBGM
//
//  Created by natha on 6/4/22.
//

import Foundation
import MediaPlayer
import AVKit

enum asmrType {
    case track
    case album
    case unknown
}

struct asmrEither: Identifiable, Equatable, Hashable, Comparable
{
    let id: UUID
    var type: asmrType
    var title: String
    var track: asmrTrack?
    var album: asmrAlbum?
    
    init<T>(_ either: T) {
        id = UUID()
        if let item = either as? asmrTrack {
            type = .track
            track = item
            album = nil
            title = item.title
            
        } else if let item = either as? asmrAlbum {
            type = .album
            track = nil
            album = item
            title = item.albumTitle
            
        } else {
            type = .unknown
            track = nil
            album = nil
            title = ""
        }
    }
    
    static func < (lhs: asmrEither, rhs: asmrEither) -> Bool{
        return lhs.title < rhs.title
    }
}
