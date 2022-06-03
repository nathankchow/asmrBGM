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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
