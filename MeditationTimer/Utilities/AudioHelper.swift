//
//  AudioHelper.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit
import AVFoundation

class AudioHelper: NSObject, AVAudioPlayerDelegate {
    
    static let shared = AudioHelper()
    static let availableSounds = [0: "None",
                                  1: "Default",
                                  2: "Zen Bell",
                                  3: "Soft",
                                  4: "Metal",
                                  5: "Strong",
                                  6: "Owl"]
    static let audioQueue = DispatchQueue(label: "audioQueue", attributes: .concurrent)
    
    var sounds: [Int: AVAudioPlayer?] = [0: nil]
    let userDefaults = UserDefaults.standard
    
    static func setAudioSession(to status: Bool) {
        // make sure sound plays even on mute
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            do {
                try AVAudioSession.sharedInstance().setActive(status)
            } catch _ as NSError {
                // print(error.localizedDescription)
            }
        } catch _ as NSError {
            // print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        AudioHelper.setAudioSession(to: false)
    }
    
    override init() {
        super.init()
        for (sound, _) in AudioHelper.availableSounds {
            configureAudioPlayer(with: sound)
        }
    }
    func play(_ bellNumber: Int) {
        // If not yet prepared, prepare
        if bellNumber > 0 && sounds[bellNumber] == nil {
            configureAudioPlayer(with: bellNumber)
            print("Audio: Reconfigured sound \(bellNumber)")
        }
        if let s = sounds[bellNumber], let sound = s {
            // Set sound volume
            if userDefaults.bool(forKey: DefaultsKeys.useSystemSound) {
                sound.volume = 1.0
            } else {
                print(AVAudioSession.sharedInstance().outputVolume)
                // TODO: Adjust formula
                let outputVolume = AVAudioSession.sharedInstance().outputVolume
                let volume = (userDefaults.float(forKey: DefaultsKeys.soundVolume) / outputVolume) * (1.4 - outputVolume)
                sound.volume = volume
                print(volume)
            }
            // Play async in separate queue
            AudioHelper.audioQueue.sync {
                AudioHelper.setAudioSession(to: true)
                sound.play()
            }
        }
    }
    
    func stop() {
        // Stop in separate queue
        AudioHelper.audioQueue.sync {
            for (sound, _) in AudioHelper.availableSounds {
                self.sounds[sound]??.stop()
                self.sounds[sound]??.currentTime = 0
            }
        }
    }
    
    func configureAudioPlayer(with bellNumber: Int) {
        // Set up gong sound
        var filename = "bell"
        if bellNumber < 10 {
            filename += "00"
        } else if bellNumber < 100 {
            filename += "0"
        }
        filename += "\(bellNumber)"
        if let sound = NSDataAsset(name: filename) {
            sounds[bellNumber] = try? AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
            sounds[bellNumber]??.delegate = self
            sounds[bellNumber]??.prepareToPlay()
        }
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
