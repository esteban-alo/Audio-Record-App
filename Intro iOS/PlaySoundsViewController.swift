//
//  PlaySoundsViewController.swift
//  Intro iOS
//
//  Created by Esteban Rodríguez Alonso on 26/03/16.
//  Copyright © 2016 Esteban Rodríguez Alonso. All rights reserved.
//

import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer!
    var audioEngine : AVAudioEngine!
    var audioFile:AVAudioFile!
    
    var receivedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(receivedAudio.title)
        // Do any additional setup after loading the view.
        /*
        if let filePath = NSBundle.mainBundle().URLForResource("movie_quote", withExtension: "mp3") {
            audioPlayer = try! AVAudioPlayer(contentsOfURL: filePath)
            audioPlayer.enableRate = true
            
        } else {
            print("The file path is empty")
        }
        */
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btn_playSlowAudio(sender: UIButton) {
        audioSpeedOptions(0.5)
    }
    
    
    @IBAction func btn_playSpeedAudio(sender: UIButton) {
        audioSpeedOptions(1.5)
    }
    
    @IBAction func btn_stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    
    @IBAction func btn_chipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func btn_darthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func audioSpeedOptions(audioSpeed:Float) {
        audioPlayer.stop()
        audioPlayer.rate = audioSpeed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
}
