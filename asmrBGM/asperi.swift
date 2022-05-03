import SwiftUI
import AVKit
import MediaPlayer
import Foundation
import Combine

final class localAudio: ObservableObject {
    @Published var localAudioList: [MPMediaItem]? = MPMediaQuery.songs().items
    
    func refreshLocalAudioList() {
        self.localAudioList = MPMediaQuery.songs().items
    }
    
    func printLocalAudioList() {
        for song in self.localAudioList ?? [] {
            print(song.title ?? "No Title")
        }
    }
}

class audioSettings: ObservableObject {
    
    var audioPlayer: AVAudioPlayer?
    var playing = false
    @Published var playValue: TimeInterval = 0.0
    @Published var playerDuration: TimeInterval? = 146
    var isPositionEditing = false
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var testSound: String = "sugar"
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                if playing == false {
                    if (audioPlayer == nil) {
                        
                        
                        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                        playerDuration = audioPlayer?.duration
                        audioPlayer?.prepareToPlay()
                        
                        audioPlayer?.play()
                        playing = true
                    }
                    
                }
                if playing == false {
                    
                    audioPlayer?.play()
                    playing = true
                }
                
                
            } catch {
                print("Could not find and play the sound file.")
            }
        }
        
    }
    
    func playAsmrURL(sound: String) {
        if let path = URL(string: sound) {
            do {
                if playing == false {
                    if (audioPlayer == nil) {
                        
                        
                        audioPlayer = try AVAudioPlayer(contentsOf: path)
                        playerDuration = audioPlayer?.duration
                        audioPlayer?.prepareToPlay()
                        
                        audioPlayer?.play()
                        playing = true
                    }
                    
                }
                if playing == false {
                    
                    audioPlayer?.play()
                    playing = true
                }
                
                
            } catch {
                print("Could not find and play the sound file.")
            }
        }
        
    }

    func stopSound() {
        //   if playing == true {
        audioPlayer?.stop()
        audioPlayer = nil
        playing = false
        playValue = 0.0
        //   }
    }
    
    func pauseSound() {
        if playing == true {
            audioPlayer?.pause()
            playing = false
        }
    }
    

    func changeSliderValue() {
        if playing == true {
            if !isPositionEditing {
                pauseSound()
                audioPlayer?.currentTime = playValue
            }
        }
        
        if playing == false {
            audioPlayer?.play()
            playing = true
        }
    }
    
    func changeSong() {
        if playing == true {
            stopSound()
        }
        if testSound == "sugar" {
            testSound = "toki"
        } else {
            testSound = "sugar"
        }
    }
}

struct asperi: View {
    @ObservedObject var audiosettings = audioSettings()
    @StateObject var localaudio = localAudio()
    @State private var playButton: Image = Image(systemName: "play.circle")
    @State private var page: Int? = 0
    @State var linkedAsmrURL: String = ""

    
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
                            if let currentTime = self.audiosettings.audioPlayer?.currentTime {
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
                Button(action: self.printStuff) {
                    Text("PRINT LOCAL AUDIO ITEMS")
                }
                NavigationLink(destination: loadAsmr(asmrURL: $linkedAsmrURL), tag: 1, selection: $page) {
                    EmptyView()
                }
                Text("Destination 1")
                    .onTapGesture {
                        self.page = 1
                    }
                Button(action: {
                    self.page = 1
                }) {
                    Text("GOTO DESTINATION 1")
                }
                Button(action: {
                    self.audiosettings.playAsmrURL(sound: linkedAsmrURL)
                }) {
                    Text("PLAY ASMR FROM URL")
                }
                Button(action: {
                    print(linkedAsmrURL)
                }) {
                    Text("DEBUG")
                }

            }
        }
        .environmentObject(localaudio)
    }
}

struct asperi_Previews: PreviewProvider {
    static var previews: some View {
        asperi()
    }
}
