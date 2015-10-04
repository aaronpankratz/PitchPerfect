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
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

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

        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
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
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to:changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to:audioEngine.outputNode, format:nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime:nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
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
