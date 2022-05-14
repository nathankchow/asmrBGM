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
import AVFAudio

class audioSettings: ObservableObject {
    
    var asmrPlayer: AVAudioPlayer?
    var bgmPlayer: AVAudioPlayer?
    var playing = false
    @Published var asmrVolume: Float = 100.0
    @Published var bgmVolume: Float = 100.0
    @Published var playValue: TimeInterval = 0.0
    @Published var playerDuration: TimeInterval? = 0.0
    @Published var asmrtrack = asmrTrack(nil) {
        didSet {
            self.stopSound()
            self.playAsmrTrack()
        }
    }
    @Published var bgmtrack = bgmTrack(nil) {
        didSet{
            print("Attempting to play BGM track.")
            self.playBgmTrack()
        }
    }
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            print(error)
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
    }
    
    var isPositionEditing = false
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var testSound: String = "sugar"
    
    func playAsmrTrack() {
        print("Sugondese nuts")
        self.playAsmrURL()
    }
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                if playing == false {
                    if (asmrPlayer == nil) {
                        
                        
                        asmrPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                        playerDuration = asmrPlayer?.duration
                        asmrPlayer?.prepareToPlay()
                        asmrPlayer?.setVolume(Float(asmrVolume/100), fadeDuration: 0)
                        asmrPlayer?.play()
                        playing = true
                    }
                    
                }
                if playing == false {
                    
                    asmrPlayer?.play()
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
                    if (asmrPlayer == nil) {
                        
                        
                        asmrPlayer = try AVAudioPlayer(contentsOf: path)
                        playerDuration = asmrPlayer?.duration
                        asmrPlayer?.prepareToPlay()
                        asmrPlayer?.setVolume(Float(asmrVolume/100), fadeDuration: 0)
                        asmrPlayer?.play()
                        playing = true
                    }
                    
                }
                if playing == false {
                    
                    asmrPlayer?.play()
                    playing = true
                }
                
                
            } catch {
                print("Could not find and play the sound file.")
            }
        }
        
    }
    
    func playBgmTrack() {
        if let path = self.bgmtrack.assetURL {
            do {
                        bgmPlayer = try AVAudioPlayer(contentsOf: path)
                        bgmPlayer?.prepareToPlay()
                        bgmPlayer?.numberOfLoops = -1
                        bgmPlayer?.setVolume(Float(bgmVolume/100), fadeDuration: 0)

                        bgmPlayer?.play()
                
            } catch {
                print("Could not find and play the sound file.")
            }
        }
        
    }

    func stopSound() {
        //   if playing == true {
        asmrPlayer?.stop()
        asmrPlayer = nil
        playing = false
        playValue = 0.0
        //   }
    }
    
    func pauseSound() {
        if playing == true {
            asmrPlayer?.pause()
            playing = false
        }
    }
    

    func changeSliderValue() {
        if playing == true {
            if !isPositionEditing {
                pauseSound()
                asmrPlayer?.currentTime = playValue
            }
        }
        
        if playing == false {
            asmrPlayer?.play()
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
