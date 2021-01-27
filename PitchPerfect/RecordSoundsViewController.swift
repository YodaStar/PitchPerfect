//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Iván Cavic on 11/01/2021.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: Properties
    
    var audioRecorder: AVAudioRecorder!
    

    @IBOutlet weak var recordingLabel: UILabel!
   
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        
    }
    

    @IBAction func recordAudio(_ sender: Any) {
        self.configureUI(record: true)
        
       
        
        // MARK: - Search for a path to store the recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
                let recordingName = "recordedVoice.wav"
                let pathArray = [dirPath, recordingName]
                let filePath = URL(string: pathArray.joined(separator: "/"))
               
        //MARK: Setup an AVAudioSession and prepare the audio recorder for recording
                let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

                try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
                
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
    
        self.configureUI(record: false)
        
        audioRecorder.stop()
                    let audioSession = AVAudioSession.sharedInstance()
                    try! audioSession.setActive(false)
            
    }
    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("recording was not successful")
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(record: Bool = false){
        recordButton.isEnabled = !record
        stopRecordingButton.isEnabled = record
        recordingLabel.text = record ? "Recording in Progress" : "Tap to Record"
    }
    
}
   

