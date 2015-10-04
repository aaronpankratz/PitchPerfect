//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Aaron Pankratz on 9/17/15.
//  Copyright (c) 2015 Aaron Pankratz. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var player : AVAudioPlayer!
    var receivedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if receivedAudio != nil {
            player = try? AVAudioPlayer(contentsOfURL:receivedAudio.filePathUrl)
        }
        else {
            if let path = NSBundle.mainBundle().pathForResource("movie_quote", ofType:"mp3") {
                let fileURL = NSURL.fileURLWithPath(path)
                player = try? AVAudioPlayer(contentsOfURL:fileURL)
            }
            else {
                print("the file path is empty")
            }
        }
        
        player.enableRate = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        playAudioWithRate(0.5)
    }
    @IBAction func playFastAudio(sender: AnyObject) {
        playAudioWithRate(2)
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
    }

    @IBAction func stopPlayback(sender: AnyObject) {
        player.currentTime = 0
        player.stop()
    }
    
    func playAudioWithRate(rate: Float) {
        player.stop()
        player.rate = rate
        player.prepareToPlay()
        player.play()
    }
}
