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
    private var player: AVPlayer!
    private var isPlaying = false
    
    func play() {
        
        let urlString = "http://streams.wtju.net:8000/wtjx-128.mp3"
        let url = NSURL(string: urlString)

        player = AVPlayer(URL: url!)
        
        print("Radio stream starting...")
        do{
            player.play()
        }
        
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