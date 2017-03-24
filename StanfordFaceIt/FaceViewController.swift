//
//  ViewController.swift
//  StanfordFaceIt
//
//  Created by Sinisa Vukovic on 09/10/16.
//  Copyright © 2016 Sinisa Vukovic. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var expression = FacialExpression(eyes: .Closed, mouth: .Frown, eyeBrows: .Furrowed) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet var faceView: FaceView! {
        didSet{
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(recognizer:))))
            let happierSwipeGestureRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappines))
            happierSwipeGestureRecogniser.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecogniser)
            
            let sadderSwipeGestureRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappines))
            sadderSwipeGestureRecogniser.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecogniser)
            updateUI()
        }
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown : -1.0, .Frin : -0.5, .Smile : 1.0, .Smirk : -0.5, .Neutral : 0.0]
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed:0.5, .Furrowed:-0.5, .Normal:0.0]
    
    private func updateUI () {
        if ((faceView) != nil) {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBorwTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
    
    func increaseHappines (){
        expression.mouth = expression.mouth.happierMouth()
    }
    func decreaseHappines() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private struct Animation {
        static let ShakeAngle = CGFloat(M_PI / 8)
        static let ShakeDuration = 0.5
    }

    @IBAction func headShake(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: Animation.ShakeDuration,
                       animations: {
                        self.faceView.transform = CGAffineTransform(rotationAngle: Animation.ShakeAngle)
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: Animation.ShakeDuration,
                               animations: {
                                self.faceView.transform = CGAffineTransform(rotationAngle: -Animation.ShakeAngle * 2)
                }) { (finished) in
                    if finished {
                        UIView.animate(withDuration: Animation.ShakeDuration,
                                       animations: {
                                        self.faceView.transform = CGAffineTransform(rotationAngle: Animation.ShakeAngle)
                        }) { (finished) in
                            
                        }
                    }
                }
            }
        }
    }
    
    func changeBrows(recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            if recognizer.rotation < CGFloat(M_PI/4){
                expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
                recognizer.rotation = 0.0
            }
            else if recognizer.rotation < -CGFloat(M_PI/4){
                expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
                recognizer.rotation = 0.0
            }
        default:
            break
        }
    }
}
