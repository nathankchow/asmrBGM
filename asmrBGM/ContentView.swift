//
//  ContentView.swift
//  asmrBgm
//
//  Created by natha on 4/13/22.
//
//mashiro URL: ipod-library://item/item.wav?id=7669358569489308532
//moyu URL: ipod-library://item/item.wav?id=7669358569489308533

import SwiftUI
import AVKit
import MediaPlayer

struct ContentView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State var audioPlayer2: AVAudioPlayer!
    @State private var asmrVol = 40.0
    @State private var bgmVol = 20.0
    @State private var pos = 5.0

    
    //hardcode for now
    var mashiro = URL(string: "ipod-library://item/item.wav?id=7669358569489308532")
    var moyu = URL(string: "ipod-library://item/item.wav?id=7669358569489308533")
    
    func foo() {
        print("Hello World!")
    }
    
    func play() {
        if !self.audioPlayer.isPlaying {
            self.audioPlayer.play()
            self.audioPlayer2.play()
        } else {
            self.audioPlayer.pause()
            self.audioPlayer2.pause()
        }
    }
    
    var body: some View {
        VStack{
            VStack{
                HStack {
                    Text("Mashiro")
                }
                HStack{
                    Text("Sakurano Mashiro")
                    Button("Edit", action: self.foo)
                }
            }
                VStack{
                    HStack {
                        Text("Moyu")
                    }
                    HStack{
                        Text("sakura moyu")
                        Button("Edit", action: self.foo)
                    }
                }
                Slider(
                    value: $pos,
                    in: 0...100,
                    step: 1
                )
        
                HStack{
                    Button("prev", action:self.foo)
                    Button("play", action:self.play)
                    Button("next", action:self.foo)
                }
                Slider(
                    value: $asmrVol,
                    in: 0...100,
                    step: 1
                )
                Slider(
                    value: $bgmVol,
                    in: 0...100,
                    step: 1
                )
            HStack{
                Button("Save Preset", action: self.foo)
                Button("Load Preset", action: self.foo)
            }
            HStack{
                Button("Options", action: self.foo)
            }

        }.onAppear{
            print("Hello World!")
            print("Hello World!")
            print("Hello World!")
        self.audioPlayer = try! AVAudioPlayer(contentsOf: mashiro!)
        self.audioPlayer2 = try! AVAudioPlayer(contentsOf: moyu!)
        //test
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//        VStack {
//            HStack {
//                Text("asmrBGM").font(.system(size: 45)).fontWeight(.bold).foregroundColor(.buttonColor)
//            }
//            HStack{
//                Button(action:
//                        {self.audioPlayer.play()
//                }) {
//                    Image(systemName: "play.circle.fill").resizable().frame(width:50, height: 50)
//                        .aspectRatio(contentMode: .fit)
//                        .foregroundColor(.buttonColor)
//                }
//            }
//            HStack{
//                Button(action:
//                        {self.audioPlayer2.play()
//                }) {
//                    Image(systemName: "play.circle.fill").resizable().frame(width:50, height: 50)
//                        .aspectRatio(contentMode: .fit)
//                        .foregroundColor(.buttonColor)
//                }
//            }
//
//        }.onAppear {
//            self.audioPlayer = try! AVAudioPlayer(contentsOf: mashiro!)
//            self.audioPlayer2 = try! AVAudioPlayer(contentsOf: moyu!)
//
//            let sound = Bundle.main.path(forResource: "asmr1", ofType: "mp3")
//            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
//            let sound2 = Bundle.main.path(forResource: "bgm1", ofType: "wav")
//            self.audioPlayer2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound2!))
//            let mediaItems = MPMediaQuery.songs().items
//            let sound3 = mediaItems![0].assetURL!
//            for item in mediaItems!{
//                print(item.title!)
//                print(item.assetURL!.absoluteString)
//            }
//            self.audioPlayer3 = try! AVAudioPlayer(contentsOf: sound3)
//        }

