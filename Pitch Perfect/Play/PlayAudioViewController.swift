//
//  PlayAudioViewController.swift
//  Pitch Perfect
//
//  Created by Tiago Oliveira on 16/10/18.
//  Copyright © 2018 Optimize 7. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioViewController: UIViewController {
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    var recordedAudioURL: URL!
    var soundPlayer: AVAudioPlayer!
    var playState: AudioState = .paused
    
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundPlayer = AVAudioPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupAudio()
        setupPlayer()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        print(sender.tag)
        playState = .playing
        switch ButtonType(rawValue: sender.tag)! {
        case .slow:
            print("SLOW")
            playEffect(rate: 0.5)
        case .fast:
            print("FAST")
            playEffect(rate: 1.5)
        case .chipmunk:
            print("CHIPMUNK")
            playEffect(pitch: 1000)
        case .vader:
            print("VADER")
            playEffect(pitch: -1000)
        case .reverb:
            print("REVERB")
            playEffect(reverb: true)
        case .echo:
            print("ECHO")
            playEffect(echo: true)
        }
        updateUI()
    }
    
    @IBAction func stopSoundForButton(_sender: UIButton) {
        
        if soundPlayer.isPlaying {
            soundPlayer.stop()
            playState = .paused
        } else {
            soundPlayer.play()
            playState = .playing
        }
        
        updateUI()
    }
    
    @objc func stopAudio() {
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        playState = .paused
        updateUI()
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    // MARK : Update UI
    
    func updateUI() {
        switch playState {
        case .paused:
            // Paused
            setMixButtonsEnabled(true)
            pauseButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        case .playing:
            // Playing
            setMixButtonsEnabled(false)
            pauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        }
    }
    
    func setMixButtonsEnabled(_ enabled: Bool) {
        snailButton.isEnabled = enabled
        chipmunkButton.isEnabled = enabled
        rabbitButton.isEnabled = enabled
        vaderButton.isEnabled = enabled
        reverbButton.isEnabled = enabled
        echoButton.isEnabled = enabled
    }
    
    func setupPlayer() {
        do {
            guard let audio = recordedAudioURL else {
                fatalError()
            }
            soundPlayer = try AVAudioPlayer(contentsOf: audio)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
