//
//  audioSettings.swift
//  asmrBGM
//
//  Created by natha on 5/5/22.
//

import SwiftUI
import AVKit
import MediaPlayer
import Foundation
import Combine

class audioSettings: ObservableObject {
    
    var audioPlayer: AVAudioPlayer?
    var playing = false
    @Published var playValue: TimeInterval = 0.0
    @Published var playerDuration: TimeInterval? = 146
    @Published var asmrtrack = asmrTrack() {
        didSet {
            self.stopSound()
            self.playAsmrTrack()
        }
    }
    var isPositionEditing = false
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var testSound: String = "sugar"
    
    func playAsmrTrack() {
        print("Sugondese nuts")
    }
    
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
    
    func playAsmrURL() {
        if let path = self.asmrtrack.assetURL {
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
