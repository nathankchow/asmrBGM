import SwiftUI
import AVKit
import MediaPlayer
import Foundation
import Combine


struct asperi: View {
    @ObservedObject var audiosettings = audioSettings()
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
                    Text("\(self.$audiosettings.asmrtrack.title.wrappedValue)\n\(self.$audiosettings.asmrtrack.artist.wrappedValue)")
                    Button(action: {
                        self.page = 1
                    }) {
                        Text("Load ASMR file")
                    }
                    Text("\(self.$audiosettings.bgmtrack.title.wrappedValue)\n\(self.$audiosettings.bgmtrack.artist.wrappedValue)")
                    Button(action: {
                        self.page = 2
                    }) {
                        Text("Load BGM file")
                    }
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
                    }
                }
                    Button(action: {
                        if (self.playButton == Image(systemName: "play.circle")) {
                            print("All Done")
                            self.audiosettings.playSound(sound: audiosettings.testSound, type: "mp3")
                            self.audiosettings.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                            self.playButton = Image(systemName: "pause.circle")
                            
                        } else {
                            print("Not done")
                            self.audiosettings.pauseSound()
                            self.playButton = Image(systemName: "play.circle")
                        }
                    }) {
                        self.playButton
                            .foregroundColor(Color.blue)
                            .font(.system(size: 44))
                    }
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
