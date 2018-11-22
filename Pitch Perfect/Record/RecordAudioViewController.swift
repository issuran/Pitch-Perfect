//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Tiago Oliveira on 16/10/18.
//  Copyright © 2018 Optimize 7. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController {
    
    // MARK : UI References
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var recordStopButton: UIButton!
    
    // MARK : Variables
    
    var viewModel = RecordAudioViewModel()
    
    var soundRecorder: AVAudioRecorder!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        setupRecorder()
    }
    
    // MARK : Setup methods
    
    func setupRecorder() {
        do {
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(.playAndRecord, mode: .default, policy: .default, options: .defaultToSpeaker)
            
            soundRecorder = try AVAudioRecorder(url: viewModel.audioFilename(), settings: [:])
            soundRecorder.delegate = self
            soundRecorder.isMeteringEnabled = true
            soundRecorder.prepareToRecord()
        } catch {
            fatalError("Error setupRecorder")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK : Buttons Action

    @IBAction func recordAudio(_ sender: Any) {
        
        if viewModel.isUserRecording() {
            stopRecorder()
        } else {
            startRecorder()
        }
    }
    
    // MARK : Start and Stop Recorder action
    
    func startRecorder() {
        recordStopButton.setImage(#imageLiteral(resourceName: "Stop"), for: .normal)
        messageLabel.text = "Tap again to stop recording"
        soundRecorder.record()
    }
    
    func stopRecorder() {
        recordStopButton.setImage(#imageLiteral(resourceName: "Record"), for: .normal)
        messageLabel.text = "Tap to record"
        soundRecorder.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
    }
    
    // MARK : Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "didFinishRecording" {
            let playAudioVC = segue.destination as! PlayAudioViewController
            let recordedAudioURL = sender as! URL
            playAudioVC.recordedAudioURL = recordedAudioURL
        }
    }
}

extension RecordAudioViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "didFinishRecording", sender: viewModel.audioFilename())
        } else {
            fatalError("Error - finishing record audio")
        }
    }
}
