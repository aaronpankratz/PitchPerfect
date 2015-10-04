//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Aaron Pankratz on 8/10/15.
//  Copyright (c) 2015 Aaron Pankratz. All rights reserved.
//

import UIKit
import AVFoundation


var audioRecorder:AVAudioRecorder!
let StopRecordingSegueId = "StopRecordingSegue"
let DefaultRecordingName = "pitch_perfect.wav"

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var recordedAudio : RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        //Hide stop button
        stopButton.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startRecordAudio(sender: UIButton) {
        recordingInProgress.hidden = false
        recordButton.enabled = false
        stopButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        
        let recordingName = DefaultRecordingName
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath, terminator: "")
        
        let session = AVAudioSession.sharedInstance()
        let errorPointer = NSErrorPointer()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            errorPointer.memory = error
        }
        
        do {
            audioRecorder = try AVAudioRecorder(URL:filePath!, settings:[:])
        } catch let error as NSError {
            errorPointer.memory = error
            audioRecorder = nil
        }
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecordAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        let errorPointer = NSErrorPointer()
        do {
            try audioSession.setActive(false)
        } catch let error as NSError {
            errorPointer.memory = error
        }
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier(StopRecordingSegueId, sender: recordedAudio)
        }
        else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StopRecordingSegueId {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

