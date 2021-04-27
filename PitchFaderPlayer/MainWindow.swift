//
//  MainWindow.swift
//  Pitch
//
//  Created by Keeper on 17/05/2018.
//  Copyright © 2018 Keeper. All rights reserved.
//

import Cocoa

class MainWindow: NSWindow {
    
    @IBOutlet weak var playButton: NSButton!
    @IBOutlet weak var pitchSlider: NSSlider!
    
    var trackPlayer = AudioPlayer()
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "BattleBreak", withExtension: "wav") else { return }
        trackPlayer.playSound(url: url, loops: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        center()
    }
    
    @IBAction func playPressed(_ sender: NSButton) {
        playSound()
    }
    
    @IBAction func pitchChanged(_ sender: NSSlider) {
        trackPlayer.pitch = sender.floatValue
    }
}
