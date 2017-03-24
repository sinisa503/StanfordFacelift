//
//  EmotionsVC.swift
//  StanfordFaceIt
//
//  Created by Sinisa Vukovic on 22/11/2016.
//  Copyright © 2016 Sinisa Vukovic. All rights reserved.
//

import UIKit

class EmotionsVC: UIViewController {

    private let emotionalFaces: Dictionary<String, FacialExpression> = ["angry":FacialExpression(eyes: .Closed, mouth: .Frown, eyeBrows: .Furrowed),
                                                                        "happy":FacialExpression(eyes: .Open, mouth: .Smile, eyeBrows: .Normal),
                                                                        "worried":FacialExpression(eyes: .Open, mouth: .Smirk, eyeBrows: .Relaxed),
                                                                        "mischievious":FacialExpression(eyes: .Open, mouth: .Frin, eyeBrows: .Furrowed)]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                var destinationVC = segue.destination
        
        if let navVC = destinationVC as? UINavigationController {
            destinationVC = navVC.visibleViewController!
        }
        
                if let faceVC = destinationVC as? FaceViewController{
                if let identifier = segue.identifier {
                if let expression = emotionalFaces[identifier]{
                faceVC.expression = expression
                    
                    if let sendingButton = sender as? UIButton {
                         faceVC.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }
}
