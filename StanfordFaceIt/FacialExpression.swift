//
//  FacialExpression.swift
//  StanfordFaceIt
//
//  Created by Sinisa Vukovic on 25/10/2016.
//  Copyright © 2016 Sinisa Vukovic. All rights reserved.
//

import Foundation

struct FacialExpression
{
    enum Eyes: Int {
        case Open
        case Closed
        case Squinting
    }
    
    enum EyeBrows: Int {
        case Relaxed
        case Normal
        case Furrowed
        
        func moreRelaxedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .Relaxed
        }
        func moreFurrowedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    enum Mouth: Int {
        case Frown
        case Smirk
        case Neutral
        case Frin
        case Smile
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    var eyes: Eyes
    var mouth: Mouth
    var eyeBrows: EyeBrows
}
