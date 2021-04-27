//
//  AudioPlayer.swift
//  Pitch
//
//  Created by Keeper on 16/04/2019.
//  Copyright © 2019 Keeper. All rights reserved.
//

import AVFoundation

class AudioPlayer: NSObject {
    
    fileprivate var audioEngine = AVAudioEngine()
    fileprivate var audioPlayerNode = AVAudioPlayerNode()
    fileprivate var timePitch = AVAudioUnitVarispeed()
    
    fileprivate var loopUrl: URL?
    
    fileprivate var fadeOutTimer = Timer()
    fileprivate let fadeOutDuration = 0.05
    fileprivate let volumeInterval: Float = 0.01
    fileprivate var canPlay = true
    
    var pitch: Float = 0.0 {
        didSet {
            timePitch.rate = pitch + 1
        }
    }
    
    override init() {
        super.init()
        setupEngine()
    }
    
    fileprivate func setupEngine() {
        audioEngine.attach(audioPlayerNode)
        
        timePitch.rate = 1
        audioEngine.attach(timePitch)
        audioEngine.connect(audioPlayerNode, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.mainMixerNode, format: nil)
        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audio engine")
        }
    }
    
    public func playSound(url: URL, loops: Bool) {
        loopUrl = url
        if canPlay {
            fadeOutAudio()
        }
    }
    
    fileprivate func fadeOutAudio() {
        canPlay = false
        let timeInterval = fadeOutDuration / (1 / Double(volumeInterval))
        fadeOutTimer = Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(fadeOutTimerDidFire),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc fileprivate func fadeOutTimerDidFire() {
        let currentVolume = audioEngine.mainMixerNode.outputVolume
        let newValue = max(currentVolume - volumeInterval, 0.0)
        audioEngine.mainMixerNode.outputVolume = newValue
        if newValue == 0.0 {
            fadeOutTimer.invalidate()
            playHandler()
            canPlay = true
        }
    }
    
    fileprivate func playHandler() {
        guard let url = loopUrl else { return }
        audioPlayerNode.stop()
        
        do {
            let audioFile = try AVAudioFile(forReading: url)
            let audioFormat = audioFile.processingFormat
            let audioFrameCount = UInt32(audioFile.length)
            let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
            try audioFile.read(into: audioFileBuffer!)
            
            audioPlayerNode.scheduleBuffer(
                audioFileBuffer!,
                at: nil,
                options: .loops,
                completionHandler: nil
            )
            audioPlayerNode.play()
            audioEngine.mainMixerNode.outputVolume = 1
        } catch {
            print(error.localizedDescription)
        }
    }
}
