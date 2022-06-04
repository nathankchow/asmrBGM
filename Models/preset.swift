//
//  preset.swift
//  asmrBGM
//
//  Created by natha on 6/4/22.
//

import Foundation
import AVKit
import MediaPlayer

struct preset: Identifiable, Equatable, Hashable, Codable, Comparable {

    let id: UUID
    var asmr: asmrEither
    var bgm: bgmTrack?
    var asmrVolume: Float
    var bgmVolume: Float

    init(_ either: asmrEither, bgm: bgmTrack?, asmrVol: Float, bgmVol: Float) {
        self.id = UUID()
        self.asmr = either
        self.bgm = bgm
        self.asmrVolume = asmrVol
        self.bgmVolume = bgmVol
    }

    static func < (lhs: preset, rhs: preset) -> Bool {
        return lhs.asmr.title < rhs.asmr.title
    }
}
