//
//  tempModelTest.swift
//  asmrBGM
//
//  Created by natha on 6/4/22.
//

import Foundation
import AVKit
import MediaPlayer

//
//  asmrEither.swift
//  asmrBGM
//
//  Created by natha on 6/4/22.
//

import Foundation
import MediaPlayer
import AVKit

enum asmrType2: Codable {
    case track
    case album
    case unknown
}

struct asmrEither2: Identifiable, Equatable, Hashable, Comparable, Codable
{
    let id: UUID
    var type: asmrType
    var title: String
    var track: asmrTrack?
    var album: asmrAlbum?
    

    static func < (lhs: asmrEither2, rhs: asmrEither2) -> Bool{
        return lhs.title < rhs.title
    }
}

