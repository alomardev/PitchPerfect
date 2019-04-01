//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by A.M.W on 3/24/19.
//  Copyright © 2019 AW. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    // For Segue
    
    let stopRecordingSegue = "stopRecording"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UI Functions
    enum recordingState { case recording, notRecording }
    
    //**** TODO: Fix the function
    func configureUIButton(_ RecordingState: recordingState) {
        //the reviewer "Francisco" helped with this shorter code, thanks to him.
        let isRecording = RecordingState == .recording
        setRecordingButtonsEnabled(!isRecording)
        stopRecordingButton.isEnabled = isRecording
        recordingLabel.text = isRecording ? "stop recording..." : "tap to record..."
    }
    
    func setRecordingButtonsEnabled(_ enabled: Bool) {
        recordingButton.isEnabled = enabled
    }
    

    @IBAction func recordAudio(_ sender: Any) {
        
      recordingLabel.text = "Recording in Progress"
      stopRecordingButton.isEnabled = true
        recordingButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap To Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // Delegate for AvAudioRecorder
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("stopped recording.")
            performSegue(withIdentifier: stopRecordingSegue, sender: audioRecorder.url)
        } else {
            print("error recording.")
        }
    }
    
    // Moving to another VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == stopRecordingSegue {
            let PlaySoundsVC = segue.destination as! PlaySoundsViewController
            let recrodedAudioURL = sender as! URL
            PlaySoundsVC.recordingAudioURL = recrodedAudioURL
        }
    }
}
    


