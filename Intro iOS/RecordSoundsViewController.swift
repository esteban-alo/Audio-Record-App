//
//  ViewController.swift
//  Intro iOS
//
//  Created by Esteban Rodríguez Alonso on 25/03/16.
//  Copyright © 2016 Esteban Rodríguez Alonso. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordedAudio : RecordedAudio!
    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var btn_record: UIButton!
    @IBOutlet weak var btn_stop: UIButton!
    @IBOutlet weak var txt_recording: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        txt_recording.hidden = false
        btn_record.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //let currentDateTime = NSDate()
        //let formatter = NSDateFormatter()
        //formatter.dateFormat = "ddMMyyyy-HHmmss"
        //let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let recordSettings = [ AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue, AVEncoderBitRateKey: 16,  AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0]
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //Setup Audio Sessions
        audioRecorder =  try! AVAudioRecorder(URL: filePath!, settings: recordSettings as! [String : AnyObject])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
   
    @IBAction func stopRecording(sender: UIButton) {
        txt_recording.hidden = true
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if (flag) {
            //Save Recorded Audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            //Perform Segue
            self.performSegueWithIdentifier("delegateRecord", sender: recordedAudio)
        } else {
            print("Recording was not succesfull")
            btn_record.enabled = true
            btn_stop.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ( segue.identifier == "delegateRecord" )
        {
            let playSoundsVC : PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}

