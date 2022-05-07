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
import Foundation

struct ContentView: View {
    @State var asmrPlayer: AVAudioPlayer!
    @State var asmrPlayer2: AVAudioPlayer!
    @State private var asmrDuration: TimeInterval = 1200.0
    @State private var asmrPosition: TimeInterval = 0.0
    @State private var asmrVol = 40.0
    @State private var bgmVol = 20.0
    @State private var pos = 0.0
    @State var playing = false
    
    //hardcode for now
    var mashiro = URL(string: "ipod-library://item/item.wav?id=7669358569489308532")
    var moyu = URL(string: "ipod-library://item/item.wav?id=7669358569489308533")
    
    func foo() {
        print("Hello World!")
    }
    
    func debug() {
#if (targetEnvironment(simulator))
        print("sim")
        #else
        print("not sim")
        #endif
    }
    
    
    func play() {
        if !self.asmrPlayer.isPlaying {
            self.asmrPlayer.play()
            self.asmrPlayer2.play()
        } else {
            self.asmrPlayer.pause()
            self.asmrPlayer2.pause()
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
//                Slider(
//                    value: $pos,
//                    in: 0...100,
//                    step: 1
//                )
                Slider(
                    value: Binding(get: {
                        self.asmrPosition / self.asmrDuration * 100
                    }, set: { (newVal) in
                        self.asmrPosition = newVal * self.asmrDuration / 100
                    }),
                    in: 0...100,
                    step: 1
                )
            Text("\(asmrPosition/asmrDuration * 100)")

                HStack{
                    Button("prev", action:self.foo)
                    Button("play", action:self.play)
                    Button("next", action:self.foo)
                }
            

                
                Slider(
                    value: Binding(get: {
                        self.asmrVol
                    }, set: { (newVal) in
                        self.asmrVol = newVal
                        self.asmrPlayer.setVolume(Float(self.asmrVol/100), fadeDuration: 0)
                    }),
                    in: 0...100,
                    step: 1)
            
            Slider(
                value: Binding(get: {
                    self.bgmVol
                }, set: { (newVal) in
                    self.bgmVol = newVal
                    self.asmrPlayer2.setVolume(Float(self.bgmVol/100), fadeDuration: 0)
                }),
                in: 0...100,
                step: 1)
            HStack{
                Button("Save Preset", action: self.foo)
                Button("Load Preset", action: self.foo)
            }
            HStack{
                Button("Options", action: self.foo)
            }
            Button("Debug", action: self.debug
                   )
    

        }.onAppear{
            #if targetEnvironment(simulator)
                        let sound = Bundle.main.path(forResource: "sugar", ofType: "mp3")
                        self.asmrPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                        
                        let sound2 = Bundle.main.path(forResource: "surely_pianuki", ofType: "mp3")
                        self.asmrPlayer2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound2!))


            #else
            self.asmrPlayer =  try! AVAudioPlayer(contentsOf: mashiro!)
                self.asmrPlayer2 = try! AVAudioPlayer(contentsOf: moyu!)
            #endif
            self.asmrPlayer.setVolume(Float(asmrVol/100), fadeDuration: 0)
            self.asmrPlayer2.setVolume(Float(bgmVol/100), fadeDuration: 0)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                print(String(self.asmrPlayer.currentTime))
            }
        }
        
        //test
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
//                        {self.asmrPlayer.play()
//                }) {
//                    Image(systemName: "play.circle.fill").resizable().frame(width:50, height: 50)
//                        .aspectRatio(contentMode: .fit)
//                        .foregroundColor(.buttonColor)
//                }
//            }
//            HStack{
//                Button(action:
//                        {self.asmrPlayer2.play()
//                }) {
//                    Image(systemName: "play.circle.fill").resizable().frame(width:50, height: 50)
//                        .aspectRatio(contentMode: .fit)
//                        .foregroundColor(.buttonColor)
//                }
//            }
//
//        }.onAppear {
//            self.asmrPlayer = try! AVAudioPlayer(contentsOf: mashiro!)
//            self.asmrPlayer2 = try! AVAudioPlayer(contentsOf: moyu!)
//
//            let sound = Bundle.main.path(forResource: "asmr1", ofType: "mp3")
//            self.asmrPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
//            let sound2 = Bundle.main.path(forResource: "bgm1", ofType: "wav")
//            self.asmrPlayer2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound2!))
//            let mediaItems = MPMediaQuery.songs().items
//            let sound3 = mediaItems![0].assetURL!
//            for item in mediaItems!{
//                print(item.title!)
//                print(item.assetURL!.absoluteString)
//            }
//            self.asmrPlayer3 = try! AVAudioPlayer(contentsOf: sound3)
//        }

