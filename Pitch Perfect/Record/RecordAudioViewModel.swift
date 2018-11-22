//
//  RecordAudioViewModel.swift
//  Pitch Perfect
//
//  Created by Tiago Oliveira on 23/10/18.
//  Copyright © 2018 Optimize 7. All rights reserved.
//

import Foundation
import AVFoundation

class RecordAudioViewModel {
    
    var audioFile: AVAudioFile!
    var fileName: String = "udacity.wav"
    var isRecording: Bool
    
    init() {
        isRecording = false
    }
    
    func isUserRecording() -> Bool {
        isRecording = !isRecording
        return !isRecording
    }
    
    func audioPath() -> String {
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.absoluteString else {
            fatalError("Needs a path")
        }
        
        return path
    }
    
    func audioFilename() -> URL {
        let pathArray = [audioPath(), fileName]
        guard let filePath = URL(string: pathArray.joined(separator: "/")) else {
            fatalError("Missing filePath")
        }
        
        return filePath
    }
}
