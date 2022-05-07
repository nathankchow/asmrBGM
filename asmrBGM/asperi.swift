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
                Text("\(self.$audiosettings.asmrtrack.title.wrappedValue)\n\(self.$audiosettings.bgmtrack.title.wrappedValue)")

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
                Button(action: {
                    print("All Done")
                    self.audiosettings.stopSound()
                    self.playButton = Image(systemName: "play.circle")
                    self.audiosettings.playValue = 0.0
                    
                }) {
                    Image(systemName: "stop.circle")
                        .foregroundColor(Color.green)
                        .font(.system(size: 44))
                }
            
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
                    self.audiosettings.changeSong()
                    self.pauseToPlay()
                    self.audiosettings.playSound(sound: audiosettings.testSound, type: "mp3")
                    self.audiosettings.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    self.playButton = Image(systemName: "pause.circle")
                    
                }) {
                    Text("CHANGE SONG TESTING")
                }

                
                NavigationLink(destination: loadAsmr(asmrtrack: self.$audiosettings.asmrtrack), tag: 1, selection: $page) {
                    EmptyView()
                }

                NavigationLink(destination: loadBgm(bgmtrack: self.$audiosettings.bgmtrack), tag: 2, selection: $page) {
                    EmptyView()
                }
                
                Button(action: {
                    self.page = 1
                }) {
                    Text("Load ASMR file")
                }

                Button(action: {
                    self.page = 2
                }) {
                    Text("Load BGM file")
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
