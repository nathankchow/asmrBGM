import SwiftUI
import AVKit
import MediaPlayer
import Foundation
import Combine
import AVFAudio

struct asperi: View {
    @StateObject var audiosettings = audioSettings()
    @StateObject var localaudio = localAudio()
    @State private var playButton: Image = Image(systemName: "play.circle")
    @State private var page: Int? = 0
    
    func pauseToPlay() {
        self.audiosettings.stopSound()
        if (self.playButton == Image(systemName: "pause.circle")) {
            self.playButton = Image(systemName: "play.circle")
            self.audiosettings.playing = false
        }
    }
    
    func printStuff() {
        self.localaudio.printLocalAudioList()
    }
    
    var body: some View {
        NavigationView{
            VStack {
                
                Group {
                    NavigationLink(destination: loadAsmr(asmrtrack: self.$audiosettings.asmrtrack), tag: 1, selection: $page) {
                        EmptyView()
                    }
                    NavigationLink(destination: loadBgm(bgmtrack: self.$audiosettings.bgmtrack), tag: 2, selection: $page) {
                        EmptyView()
                    }
                }
                
                Group {
                    Text("\(self.audiosettings.asmrtrack.title)\n\(self.audiosettings.asmrtrack.artist)")
                    Button(action: {
                        self.page = 1
                    }) {
                        Text("Load ASMR file")
                    }
                    Text("\(self.audiosettings.bgmtrack.title)\n\(self.audiosettings.bgmtrack.artist)")
                    Button(action: {
                        self.page = 2
                    }) {
                        Text("Load BGM file")
                    }
                }.onChange(of: self.$audiosettings.asmrtrack.wrappedValue) { _ in
                    if (self.playButton == Image(systemName: "play.circle")) {
                        print("All Done")
                        self.audiosettings.playAsmrURL()
                        self.audiosettings.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        self.audiosettings.bgmPlayer?.play()
                        self.playButton = Image(systemName: "pause.circle")
                    }
                    print("Why does this print 4 times? XD ")
                    
                    //ATTENTION: this prints 4 messages, need to learn why
                    
                }
                
                Group {
            
                Slider(value: $audiosettings.playValue, in: TimeInterval(0.0)...audiosettings.playerDuration!, onEditingChanged: { editing in
                self.audiosettings.isPositionEditing = editing
                self.audiosettings.changeSliderValue()
            })
                .onReceive(audiosettings.timer) { _ in
                    print(self.audiosettings.isPositionEditing)
                    if self.audiosettings.playing {
                        if !self.audiosettings.isPositionEditing {
                            if let currentTime = self.audiosettings.asmrPlayer?.currentTime {
                                self.audiosettings.playValue = currentTime
                            
                                if currentTime == TimeInterval(0.0) {
                                    self.audiosettings.playing = false
                                    self.playButton = Image(systemName: "play.circle")
                                }
                            }
                        }
                        
                    }
                    else {
                        self.audiosettings.playing = false
                        self.audiosettings.timer.upstream.connect().cancel()
                        self.audiosettings.bgmPlayer?.stop()
                        self.audiosettings.bgmPlayer?.prepareToPlay()
                    }
                }
                    Button(action: {
                        if (self.playButton == Image(systemName: "play.circle")) {
                            print("All Done")
                            self.audiosettings.playAsmrURL()
                            self.audiosettings.bgmPlayer?.play()
                            self.audiosettings.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                            self.playButton = Image(systemName: "pause.circle")
                            
                        } else {
                            print("Not done")
                            self.audiosettings.pauseSound()
                            self.audiosettings.bgmPlayer?.pause()
                            self.playButton = Image(systemName: "play.circle")
                        }
                    }) {
                        self.playButton
                            .foregroundColor(Color.blue)
                            .font(.system(size: 44))
                    }
                    
                    Slider(
                        value: Binding(get: {
                            self.audiosettings.asmrVolume
                        }, set: { (newVal) in
                            self.audiosettings.asmrVolume = newVal
                            self.audiosettings.asmrPlayer?.setVolume(Float(self.audiosettings.asmrVolume/100), fadeDuration: 0)
                        }),
                        in: 0...100,
                        step: 1)
                
                Slider(
                    value: Binding(get: {
                        self.audiosettings.bgmVolume
                    }, set: { (newVal) in
                        self.audiosettings.bgmVolume = newVal
                        self.audiosettings.bgmPlayer?.setVolume(Float(self.audiosettings.bgmVolume/100), fadeDuration: 0)
                    }),
                    in: 0...100,
                    step: 1)
//                Button(action: {
//                    self.audiosettings.changeSong()
//                    self.pauseToPlay()
//                    self.audiosettings.playSound(sound: audiosettings.testSound, type: "mp3")
//                    self.audiosettings.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//                    self.playButton = Image(systemName: "pause.circle")
//
//                }) {
//                    Text("CHANGE SONG TESTING")
//                }

                

                



                }

            }
        }
    }
}

struct asperi_Previews: PreviewProvider {
    static var previews: some View {
        asperi()
    }
}
