//
//  loadPreset.swift
//  asmrBGM
//
//  Created by natha on 6/4/22.
//

import SwiftUI
import Foundation
import Combine
import AVKit
import MediaPlayer

struct loadPreset: View, Equatable {
    static func == (lhs: loadPreset, rhs: loadPreset) -> Bool {
        return true
    }
    
    @Binding var asmrtrack: asmrTrack
    @Binding var bgmtrack: bgmTrack
    @Binding var asmralbum: asmrAlbum
    @Binding var asmrvol: Float
    @Binding var bgmvol: Float
    @Environment(\.presentationMode) var presentationMode

    
    @ObservedObject private var store = PresetStore()
    var body: some View {
        VStack {
        List {
            ForEach(store.presets, id: \.self) { item in
                switch (item.asmr.type) {
                case .album:
                    VStack{
                        HStack{
                        Text(item.asmr.title)
                            .foregroundColor(.purple)
                            Spacer()
                        }
                        HStack{
                            Text(item.bgm?.title ?? "No BGM")
                            Spacer()
                        }
                        HStack{
                            Text(String(Int(item.asmrVolume)))
                            Spacer()
                        }
                        HStack{
                            Text(String(Int(item.bgmVolume)))
                            Spacer()
                        }
                    }.contentShape(Rectangle())
                        .onTapGesture {
                            asmralbum = item.asmr.album!
                            bgmtrack = item.bgm ?? bgmTrack(nil)
                            asmrvol = item.asmrVolume
                            bgmvol = item.bgmVolume
                            presentationMode.wrappedValue.dismiss()
                        }
                case .track:
                    VStack{
                        HStack{
                            Text(item.asmr.title)
                            Spacer()
                        }
                        HStack{
                            Text(item.bgm?.title ?? "No BGM")
                            Spacer()
                        }
                        HStack{
                            Text(String(Int(item.asmrVolume)))
                            Spacer()
                        }
                        HStack{
                            Text(String(Int(item.bgmVolume)))
                            Spacer()
                        }
                    }.contentShape(Rectangle())
                        .onTapGesture {
                        asmrtrack = item.asmr.track!
                        bgmtrack = item.bgm ?? bgmTrack(nil)
                        asmrvol = item.asmrVolume
                        bgmvol = item.bgmVolume
                        presentationMode.wrappedValue.dismiss()
                    }
                default:
                    Text("neither album or track?")
                }
            }.onDelete(perform: delete)
        }

    }.onAppear{
            PresetStore.load {result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    store.presets = []
                    //fatalError(error.localizedDescription)
                case .success (let presets):
                    store.presets = presets
                }
            }
        }
        
    }
    func deleteAll() {
        store.presets = []
        PresetStore.save(presets: store.presets) { result in
            if case .failure (let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func delete (at offsets: IndexSet) {
        store.presets.remove(atOffsets: offsets)
        PresetStore.save(presets: store.presets) { result in
            if case .failure (let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
}

struct loadPreset_Previews: PreviewProvider {
    static var previews: some View {
        loadPreset(
            asmrtrack: .constant(asmrTrack(nil)),
            bgmtrack: .constant(bgmTrack(nil)),
            asmralbum: .constant(asmrAlbum([])),
            asmrvol: .constant(Float(100)),
            bgmvol: .constant(Float(100))
        )
    }
}
