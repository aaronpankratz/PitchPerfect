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

    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = NSBundle.mainBundle().pathForResource("movie_quote", ofType:"mp3") {
            let fileURL = NSURL.fileURLWithPath(path)
            player = try? AVAudioPlayer(contentsOfURL:fileURL)
            player.enableRate = true
        }
        else {
            print("the file path is empty")
        }

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
