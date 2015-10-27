//
//  RadioStream.swift
//  WXTJRadio
//
//  Created by Andrew Kovalenko on 10/25/15.
//  Copyright © 2015 University of Virginia. All rights reserved.
//

import Foundation
import AVFoundation


class RadioStream {
    static let sharedInstance = RadioStream()
    private var player = AVPlayer(URL: NSURL(string: "http://streams.wtju.net:8000/wtjx-128.mp3")!)
    private var isPlaying = false
    
    func play() {
        print("Radio stream starting...")
        player.play()
        
        print(player.volume)
        
        isPlaying = true
    }
    
    func pause() {
        print("Radio stream pausing...")
        player.pause()
        isPlaying = false
    }
    
    func toggle() {
        if isPlaying == true {
            pause()
        } else {
            play()
        }
    }
    
    func currentlyPlaying() -> Bool {
        return isPlaying
    }
    
}