//
//  BlinkingFaceVC.swift
//  StanfordFaceIt
//
//  Created by Sinisa Vukovic on 15/12/2016.
//  Copyright © 2016 Sinisa Vukovic. All rights reserved.
//

import UIKit

class BlinkingFaceVC: FaceViewController {
    
    var blinking: Bool = false {
        didSet{
            startBlinking()
        }
    }
    
    private struct BlinkRate {
        static let ClosedDuration = 0.4
        static let OpenDuration = 2.5
    }
    
    func startBlinking() {
        print("Start Blinking")
        if blinking {
            faceView.eyesOpen = false
            Timer.scheduledTimer(
                timeInterval:BlinkRate.ClosedDuration,
                target: self,
                selector: #selector(BlinkingFaceVC.endBlinking),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    @objc private func endBlinking() {
        print("End Blinking")
        faceView.eyesOpen = true
        Timer.scheduledTimer(
            timeInterval:BlinkRate.OpenDuration,
            target: self,
            selector: #selector(BlinkingFaceVC.startBlinking),
            userInfo: nil,
            repeats: false
        )
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        blinking = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        blinking = false
    }
}
